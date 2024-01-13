#define TRANSIT_DEAD_CYCLES_TO_GRAVEYARD 4

/datum/transit_instance
	var/datum/virtual_level/vlevel
	var/obj/docking_port/stationary/transit/dock
	var/datum/overmap_object/shuttle/overmap_shuttle
	//Associative for easy lookup
	var/list/affected_movables = list()
	var/process_time = 0
	var/dead_cycles = 0

/datum/transit_instance/process(delta_time)
	if(overmap_shuttle == null)
		return
	process_time += delta_time
	while(process_time >= 60) // delta time is 1/10th's of normal time measurement?? what a joke
		process_time -= 60
		check_dead_cycle()

/datum/transit_instance/proc/check_dead_cycle()
	if(vlevel == null)
		return
	var/list/alive_client_mobs = vlevel.get_alive_client_mobs()
	var/dead = (alive_client_mobs.len == 0) ? TRUE : FALSE
	var/obj/docking_port/mobile/shuttle = dock.get_docked()
	if(shuttle == null)
		dead = FALSE
	if(dead)
		dead_cycles++
		if(dead_cycles >= TRANSIT_DEAD_CYCLES_TO_GRAVEYARD)
			send_to_graveyard()
	else
		dead_cycles = 0

/datum/transit_instance/proc/send_to_graveyard()
	var/obj/docking_port/mobile/shuttle = dock.get_docked()
	if(shuttle == null)
		return
	var/list/docks = SSmapping.ship_graveyard_map_zone.get_docks_for_shuttle(shuttle)
	if(docks.len == 0)
		return
	var/obj/docking_port/stationary/target_dock = docks[1]
	message_admins("Ship was sent to Ship Graveyard due to no alive clients on board and inactivity [ADMIN_VERBOSEJMP(target_dock)]")
	SSshuttle.moveShuttle(shuttle.id, target_dock.id, FALSE)

/datum/transit_instance/New(datum/virtual_level/arg_vlevel, obj/docking_port/stationary/transit/arg_dock)
	. = ..()
	vlevel = arg_vlevel
	vlevel.transit_instance = src
	dock = arg_dock
	dock.transit_instance = src
	START_PROCESSING(SStransit_instance, src)

/datum/transit_instance/Destroy()
	strand_all()
	vlevel.transit_instance = null
	vlevel = null
	dock.transit_instance = null
	dock = null
	overmap_shuttle = null
	return ..()

//Movable moved in transit
/datum/transit_instance/proc/movable_moved(atom/movable/moved, time_until_strand)
	if(!moved)
		stack_trace("null movable on Movable Moved in Transit Instance")
		return
	if(!moved.loc || !isturf(moved.loc))
		return
	if(time_until_strand > world.time)
		return
	var/turf/my_turf = moved.loc
	if(!vlevel.on_edge(my_turf))
		return
	//We've moved to be adjacent to edge or out of bounds
	//Check for things that should just disappear as they bump into the edges of the map
	//Maybe listening for this event could be done in a better way?
	strand_act(moved)

//Apply velocity to the movables we're handling
/datum/transit_instance/proc/ApplyVelocity(dir, velocity)
	var/velocity_stage
	switch(velocity)
		if(0 to 0.5)
			velocity_stage = TRANSIT_VELOCITY_NEGLIGIBLE
		if(0.5 to 1)
			velocity_stage = TRANSIT_VELOCITY_LOW
		if(1 to 1.5)
			velocity_stage = TRANSIT_VELOCITY_MEDIUM
		if(2 to INFINITY)
			velocity_stage = TRANSIT_VELOCITY_HIGH
	if(!velocity_stage)
		return
	for(var/i in affected_movables)
		var/atom/movable/movable = i
		if(QDELETED(movable))
			continue
		if(movable.anchored)
			continue
		var/turf/my_turf = get_turf(movable)
		if(!my_turf)
			continue
		var/turf/step_turf = get_step(my_turf, dir)
		//Medium velocity, and someone gets bumped against an edge turf
		if(velocity_stage >= TRANSIT_VELOCITY_MEDIUM && vlevel.on_edge_reservation(step_turf))
			strand_act(movable)
			continue
		//Huge velocity, check if we get squashed against something that blocks us
		if(velocity_stage >= TRANSIT_VELOCITY_HIGH && isliving(movable))
			var/mob/living/movable_mob = movable
			if(isclosedturf(step_turf) || step_turf.is_blocked_turf(TRUE))
				movable_mob.gib(FALSE, FALSE, FALSE)
				continue
		//If velocity is medium, mobs can still hold onto things to avoid being thrown
		if(velocity_stage <= TRANSIT_VELOCITY_MEDIUM && isliving(movable))
			if(movable.Process_Spacemove())
				continue
			for(var/cardinal in GLOB.cardinals)
				var/turf/cardinal_turf = get_step(my_turf, cardinal)
				if(!istype(cardinal_turf, /turf/open/space/transit))
					continue
		if(!isclosedturf(step_turf) && !step_turf.is_blocked_turf(TRUE))
			movable.throw_at(get_edge_target_turf(my_turf, dir), 4, 2)

///Strand all movables that we're managing
/datum/transit_instance/proc/strand_all()
	for(var/movable in affected_movables)
		strand_act(movable)

/datum/transit_instance/proc/strand_act(atom/movable/strander)
	var/commit_strand = FALSE
	var/name_to_apply
	if(ishuman(strander))
		strand_human_on_dedicated_level(strander)
		return
	else if (istype(strander, /obj/structure/closet))
		commit_strand = TRUE
		name_to_apply = "stranded cargo"
	else if(ismob(strander))
		var/mob/strander_mob = strander
		if(strander_mob.client)
			commit_strand = TRUE
			name_to_apply = "stranded creature"
	if(!commit_strand)
		qdel(strander)
		return
	var/turf/turfer = locate(1,1,1)
	strander.forceMove(turfer) //Lots of things doesn't like being in nullspace, huff
	var/overmap_y = 1
	var/overmap_x = 1
	var/overmap_system = SSovermap.main_system
	if(overmap_shuttle)
		overmap_x = overmap_shuttle.x
		overmap_y = overmap_shuttle.y
		overmap_system = overmap_shuttle.current_system
	var/datum/overmap_object/transportable/stranded/stranded_ovo = new(overmap_system, overmap_x, overmap_y)
	stranded_ovo.StoreStranded(strander, name_to_apply)
	if(ismob(strander))
		var/mob/strander_mob = strander
		to_chat(strander_mob, SPAN_USERDANGER("You have been stranded in the empty void of space! Your body is able to be recovered by someone picking it up with a transporter."))

/datum/transit_instance/proc/strand_human_on_dedicated_level(mob/living/carbon/human/human)
	var/datum/map_zone/mapzone = SSmapping.strand_map_zone
	if(mapzone == null)
		return
	to_chat(human, SPAN_USERDANGER("You fell outside of your ship and floated away to a cluster of asteroids!"))
	var/datum/virtual_level/vlevel = mapzone.virtual_levels[1]
	var/turf/strand_location = vlevel.get_side_turf(NONE, 0, FALSE)
	var/turf/center_location = vlevel.get_center()
	human.forceMove(strand_location)
	human.throw_at(center_location, 4, 2)
	return
