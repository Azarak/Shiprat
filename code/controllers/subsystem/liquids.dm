SUBSYSTEM_DEF(liquids)
	name = "Liquid Turfs"
	wait = 1 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/active_turfs = list()
	var/list/currentrun_active_turfs = list()

	var/list/active_groups = list()

	var/list/active_immutables = list()

	var/list/evaporation_queue = list()
	var/evaporation_counter = 0 //Only process evaporation on intervals

	var/list/singleton_immutables = list()

	var/run_type = SSLIQUIDS_RUN_TYPE_TURFS

/datum/controller/subsystem/liquids/proc/get_immutable(type)
	if(!singleton_immutables[type])
		var/obj/effect/abstract/liquid_turf/immutable/new_one = new type()
		singleton_immutables[type] = new_one
	return singleton_immutables[type]


/datum/controller/subsystem/liquids/stat_entry(msg)
	msg += "AT:[active_turfs.len]|AG:[active_groups.len]|AIM:[active_immutables.len]|EQ:[evaporation_queue.len]"
	return ..()


/datum/controller/subsystem/liquids/fire(resumed = FALSE)
	if(run_type == SSLIQUIDS_RUN_TYPE_TURFS)
		if(!currentrun_active_turfs.len && active_turfs.len)
			currentrun_active_turfs = active_turfs.Copy()
		for(var/tur in currentrun_active_turfs)
			if(MC_TICK_CHECK)
				return
			var/turf/T = tur
			T.process_liquid_cell()
			currentrun_active_turfs -= T //work off of index later
		if(!currentrun_active_turfs.len)
			run_type = SSLIQUIDS_RUN_TYPE_GROUPS
	if (run_type == SSLIQUIDS_RUN_TYPE_GROUPS)
		for(var/g in active_groups)
			var/datum/liquid_group/LG = g
			if(LG.dirty)
				LG.share()
				LG.dirty = FALSE
			else if(!LG.amount_of_active_turfs)
				LG.decay_counter++
				if(LG.decay_counter >= LIQUID_GROUP_DECAY_TIME)
					//Perhaps check if any turfs in here can spread before removing it? It's not unlikely they would
					LG.break_group()
			if(MC_TICK_CHECK)
				return
		run_type = SSLIQUIDS_RUN_TYPE_IMMUTABLES
	if(run_type == SSLIQUIDS_RUN_TYPE_IMMUTABLES)
		for(var/t in active_immutables)
			var/turf/T = t
			T.process_immutable_liquid()

			if(MC_TICK_CHECK)
				return

		run_type = SSLIQUIDS_RUN_TYPE_EVAPORATION

	if(run_type == SSLIQUIDS_RUN_TYPE_EVAPORATION)
		evaporation_counter++
		if(evaporation_counter >= REQUIRED_EVAPORATION_PROCESSES)
			for(var/t in evaporation_queue)
				var/turf/T = t
				if(prob(EVAPORATION_CHANCE))
					T.liquids.process_evaporation()
				if(MC_TICK_CHECK)
					return
			evaporation_counter = 0
		run_type = SSLIQUIDS_RUN_TYPE_TURFS

/datum/controller/subsystem/liquids/proc/add_active_turf(turf/T)
	if(!active_turfs[T])
		active_turfs[T] = TRUE
		if(T.lgroup)
			T.lgroup.amount_of_active_turfs++

/datum/controller/subsystem/liquids/proc/remove_active_turf(turf/T)
	if(active_turfs[T])
		active_turfs -= T
		if(T.lgroup)
			T.lgroup.amount_of_active_turfs--

/turf
	var/obj/effect/abstract/liquid_turf/liquids
	var/liquid_height = 0
	var/turf_height = 0

/turf/proc/convert_immutable_liquids()
	if(!liquids || !liquids.immutable)
		return
	var/datum/reagents/tempr = liquids.take_reagents_flat(liquids.total_reagents)
	var/cached_height = liquids.height
	liquids.remove_turf(src)
	liquids = new(src)
	liquids.height = cached_height //Prevent height effects
	add_liquid_from_reagents(tempr)
	qdel(tempr)

/turf/proc/reasses_liquids()
	if(!liquids)
		return
	if(lgroup)
		lgroup.remove_from_group(src)
	SSliquids.add_active_turf(src)

/obj/effect/abstract/liquid_turf/proc/liquid_simple_delete_flat(flat_amount)
	if(flat_amount >= total_reagents)
		qdel(src, TRUE)
		return
	var/fraction = flat_amount/total_reagents
	for(var/reagent_type in reagent_list)
		var/amount = fraction * reagent_list[reagent_type]
		reagent_list[reagent_type] -= amount
		total_reagents -= amount
	has_cached_share = FALSE
	if(!my_turf.lgroup)
		calculate_height()

/turf/proc/liquid_fraction_delete(fraction)
	for(var/r_type in liquids.reagent_list)
		var/volume_change = liquids.reagent_list[r_type] * fraction
		liquids.reagent_list[r_type] -= volume_change
		liquids.total_reagents -= volume_change

/turf/proc/liquid_fraction_share(turf/T, fraction)
	if(!liquids)
		return
	if(fraction > 1)
		CRASH("Fraction share more than 100%")
	for(var/r_type in liquids.reagent_list)
		var/volume_change = liquids.reagent_list[r_type] * fraction
		liquids.reagent_list[r_type] -= volume_change
		liquids.total_reagents -= volume_change
		T.add_liquid(r_type, volume_change, TRUE, liquids.temp)
	liquids.has_cached_share = FALSE

/turf/proc/liquid_update_turf()
	if(liquids && liquids.immutable)
		SSliquids.active_immutables[src] = TRUE
		return
	//Check atmos adjacency to cut off any disconnected groups
	if(lgroup)
		var/assoc_atmos_turfs = list()
		for(var/tur in GetAtmosAdjacentTurfs())
			assoc_atmos_turfs[tur] = TRUE
		//Check any cardinals that may have a matching group
		for(var/direction in GLOB.cardinals)
			var/turf/T = get_step(src, direction)
			//Same group of which we do not share atmos adjacency
			if(!assoc_atmos_turfs[T] && T.lgroup && T.lgroup == lgroup)
				T.lgroup.check_adjacency(T)

	SSliquids.add_active_turf(src)

/turf/proc/add_liquid_from_reagents(datum/reagents/giver, no_react = FALSE)
	var/list/compiled_list = list()
	for(var/r in giver.reagent_list)
		var/datum/reagent/R = r
		compiled_list[R.type] = R.volume
	add_liquid_list(compiled_list, no_react, giver.chem_temp)

//More efficient than add_liquid for multiples
/turf/proc/add_liquid_list(reagent_list, no_react = FALSE, chem_temp = 300)
	if(!liquids)
		liquids = new(src)
	if(liquids.immutable)
		return

	var/prev_total_reagents = liquids.total_reagents
	var/prev_thermal_energy = prev_total_reagents * liquids.temp

	for(var/reagent in reagent_list)
		if(!liquids.reagent_list[reagent])
			liquids.reagent_list[reagent] = 0
		liquids.reagent_list[reagent] += reagent_list[reagent]
		liquids.total_reagents += reagent_list[reagent]

	var/recieved_thermal_energy = (liquids.total_reagents - prev_total_reagents) * chem_temp
	liquids.temp = (recieved_thermal_energy + prev_thermal_energy) / liquids.total_reagents

	if(!no_react)
		//We do react so, make a simulation
		create_reagents(10000) //Reagents are on turf level, should they be on liquids instead?
		reagents.add_reagent_list(liquids.reagent_list, no_react = TRUE)
		reagents.chem_temp = liquids.temp
		if(reagents.handle_reactions())//Any reactions happened, so re-calculate our reagents
			liquids.reagent_list = list()
			liquids.total_reagents = 0
			for(var/r in reagents.reagent_list)
				var/datum/reagent/R = r
				liquids.reagent_list[R.type] = R.volume
				liquids.total_reagents += R.volume

			liquids.temp = reagents.chem_temp
			if(!liquids.total_reagents) //Our reaction exerted all of our reagents, remove self
				qdel(reagents)
				qdel(liquids)
				return
		qdel(reagents)
		//Expose turf
		liquids.ExposeMyTurf()

	liquids.calculate_height()
	liquids.set_reagent_color_for_liquid()
	liquids.has_cached_share = FALSE
	SSliquids.add_active_turf(src)
	if(lgroup)
		lgroup.dirty = TRUE

/turf/proc/add_liquid(reagent, amount, no_react = FALSE, chem_temp = 300)
	if(!liquids)
		liquids = new(src)
	if(liquids.immutable)
		return

	var/prev_thermal_energy = liquids.total_reagents * liquids.temp

	if(!liquids.reagent_list[reagent])
		liquids.reagent_list[reagent] = 0
	liquids.reagent_list[reagent] += amount
	liquids.total_reagents += amount

	liquids.temp = ((amount * chem_temp) + prev_thermal_energy) / liquids.total_reagents

	if(!no_react)
		//We do react so, make a simulation
		create_reagents(10000)
		reagents.add_reagent_list(liquids.reagent_list, no_react = TRUE)
		if(reagents.handle_reactions())//Any reactions happened, so re-calculate our reagents
			liquids.reagent_list = list()
			liquids.total_reagents = 0
			for(var/r in reagents.reagent_list)
				var/datum/reagent/R = r
				liquids.reagent_list[R.type] = R.volume
				liquids.total_reagents += R.volume
			liquids.temp = reagents.chem_temp
		qdel(reagents)
		//Expose turf
		liquids.ExposeMyTurf()

	liquids.calculate_height()
	liquids.set_reagent_color_for_liquid()
	liquids.has_cached_share = FALSE
	SSliquids.add_active_turf(src)
	if(lgroup)
		lgroup.dirty = TRUE

/obj/effect/abstract/liquid_turf
	name = "liquid"
	icon = 'icons/effects/liquid.dmi'
	icon_state = "water-0"
	base_icon_state = "water"
	anchored = TRUE
	plane = FLOOR_PLANE
	color = "#DDF"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WATER)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WATER)

	mouse_opacity = FALSE
	var/height = 1
	var/only_big_diffs = 1
	var/turf/my_turf
	var/liquid_state = LIQUID_STATE_PUDDLE
	var/has_cached_share = FALSE

	var/attrition = 0

	var/immutable = FALSE

	var/list/reagent_list = list()
	var/total_reagents = 0
	var/temp = T20C

	var/no_effects = FALSE

/obj/effect/abstract/liquid_turf/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/effect/abstract/liquid_turf/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	return

/obj/effect/abstract/liquid_turf/proc/burn_and_get_power()
	var/total_burn_power = 0
	var/datum/reagent/R //Faster declaration
	for(var/reagent_type in reagent_list)
		R = reagent_type
		var/burn_power = initial(R.accelerant_quality)
		if(burn_power)
			total_burn_power += burn_power * reagent_list[reagent_type]
	if(!total_burn_power)
		return FALSE
	total_burn_power /= total_reagents //We get burn power per unit.
	if(total_burn_power <= REQUIRED_FIRE_POWER_PER_UNIT)
		return 0
	// burn out the reagents
	for(var/reagent_type in reagent_list)
		R = reagent_type
		var/amt = reagent_list[reagent_type]
		if(LIQUIDS_ACCELERANT_BURN_RATE >= amt)
			reagent_list -= reagent_type
			total_reagents -= amt
		else
			reagent_list[reagent_type] -= LIQUIDS_ACCELERANT_BURN_RATE
			total_reagents -= LIQUIDS_ACCELERANT_BURN_RATE
	has_cached_share = FALSE
	if(total_reagents <= 0)
		qdel(src, TRUE)
	// finally return the burn power
	return total_burn_power * LIQUIDS_ACCELERANT_BURN_POWER_MULTIPLIER

/obj/effect/abstract/liquid_turf/proc/liquid_hotspot_exposed()
	if(!my_turf)
		return
	var/turf/open/open_turf = my_turf
	if(!istype(open_turf))
		return
	if(open_turf.turf_fire)
		return
	var/power = burn_and_get_power()
	if(power == 0)
		return
	open_turf.IgniteTurf(power)

/obj/effect/abstract/liquid_turf/proc/process_evaporation()
	if(immutable)
		SSliquids.evaporation_queue -= my_turf
		return
	//We're in a group. dont try and evaporate
	if(my_turf.lgroup)
		SSliquids.evaporation_queue -= my_turf
		return
	if(liquid_state != LIQUID_STATE_PUDDLE)
		SSliquids.evaporation_queue -= my_turf
		return
	//See if any of our reagents evaporates
	var/any_change = FALSE
	var/datum/reagent/R //Faster declaration
	for(var/reagent_type in reagent_list)
		R = reagent_type
		//We evaporate. bye bye
		if(initial(R.evaporates))
			total_reagents -= reagent_list[reagent_type]
			reagent_list -= reagent_type
			any_change = TRUE
	if(!any_change)
		SSliquids.evaporation_queue -= my_turf
		return
	//No total reagents. Commit death
	if(reagent_list.len == 0)
		qdel(src, TRUE)
	//Reagents still left. Recalculte height and color and remove us from the queue
	else
		has_cached_share = FALSE
		SSliquids.evaporation_queue -= my_turf
		calculate_height()
		set_reagent_color_for_liquid()

/obj/effect/abstract/liquid_turf/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()

/obj/effect/abstract/liquid_turf/proc/set_new_liquid_state(new_state)
	liquid_state = new_state
	update_appearance()

/obj/effect/abstract/liquid_turf/update_overlays()
	. = ..()
	if(no_effects)
		return
	switch(liquid_state)
		if(LIQUID_STATE_ANKLES)
			var/mutable_appearance/overlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage1_bottom")
			var/mutable_appearance/underlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage1_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = GATEWAY_UNDERLAY_LAYER
			. += overlay
			. += underlay
		if(LIQUID_STATE_WAIST)
			var/mutable_appearance/overlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage2_bottom")
			var/mutable_appearance/underlay = mutable_appearance('icons//effects/liquid_overlays.dmi', "stage2_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = GATEWAY_UNDERLAY_LAYER
			. += overlay
			. += underlay
		if(LIQUID_STATE_SHOULDERS)
			var/mutable_appearance/overlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage3_bottom")
			var/mutable_appearance/underlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage3_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = GATEWAY_UNDERLAY_LAYER
			. += overlay
			. += underlay
		if(LIQUID_STATE_FULLTILE)
			var/mutable_appearance/overlay = mutable_appearance('icons/effects/liquid_overlays.dmi', "stage4_bottom")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			. += overlay
	if(liquid_state == LIQUID_STATE_PUDDLE)
		var/mutable_appearance/overlay = mutable_appearance('icons/effects/liquid.dmi', "shine")
		overlay.appearance_flags = RESET_ALPHA | RESET_COLOR
		. += overlay

//Takes a flat of our reagents and returns it, possibly qdeling our liquids
/obj/effect/abstract/liquid_turf/proc/take_reagents_flat(flat_amount)
	var/datum/reagents/tempr = new(10000)
	if(flat_amount >= total_reagents)
		tempr.add_reagent_list(reagent_list, no_react = TRUE)
		qdel(src, TRUE)
	else
		var/fraction = flat_amount/total_reagents
		var/passed_list = list()
		for(var/reagent_type in reagent_list)
			var/amount = fraction * reagent_list[reagent_type]
			reagent_list[reagent_type] -= amount
			total_reagents -= amount
			passed_list[reagent_type] = amount
		tempr.add_reagent_list(passed_list, no_react = TRUE)
		has_cached_share = FALSE
	tempr.chem_temp = temp
	return tempr

/obj/effect/abstract/liquid_turf/immutable/take_reagents_flat(flat_amount)
	return simulate_reagents_flat(flat_amount)

//Returns a reagents holder with all the reagents with a higher volume than the threshold
/obj/effect/abstract/liquid_turf/proc/simulate_reagents_threshold(amount_threshold)
	var/datum/reagents/tempr = new(10000)
	var/passed_list = list()
	for(var/reagent_type in reagent_list)
		var/amount = reagent_list[reagent_type]
		if(amount_threshold && amount < amount_threshold)
			continue
		passed_list[reagent_type] = amount
	tempr.add_reagent_list(passed_list, no_react = TRUE)
	tempr.chem_temp = temp
	return tempr

//Returns a flat of our reagents without any effects on the liquids
/obj/effect/abstract/liquid_turf/proc/simulate_reagents_flat(flat_amount)
	var/datum/reagents/tempr = new(10000)
	if(flat_amount >= total_reagents)
		tempr.add_reagent_list(reagent_list, no_react = TRUE)
	else
		var/fraction = flat_amount/total_reagents
		var/passed_list = list()
		for(var/reagent_type in reagent_list)
			var/amount = fraction * reagent_list[reagent_type]
			passed_list[reagent_type] = amount
		tempr.add_reagent_list(passed_list, no_react = TRUE)
	tempr.chem_temp = temp
	return tempr

/obj/effect/abstract/liquid_turf/fire_act(temperature, volume)
	// TODO
	return

/obj/effect/abstract/liquid_turf/proc/set_reagent_color_for_liquid()
	color = mix_color_from_reagent_list(reagent_list)

/obj/effect/abstract/liquid_turf/proc/calculate_height()
	var/new_height = CEILING(total_reagents, 1)/LIQUID_HEIGHT_DIVISOR
	set_height(new_height)
	var/determined_new_state
	//We add the turf height if it's positive to state calculations
	if(my_turf.turf_height > 0)
		new_height += my_turf.turf_height
	switch(new_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			determined_new_state = LIQUID_STATE_FULLTILE
	if(determined_new_state != liquid_state)
		set_new_liquid_state(determined_new_state)

/obj/effect/abstract/liquid_turf/immutable/calculate_height()
	var/new_height = CEILING(total_reagents, 1)/LIQUID_HEIGHT_DIVISOR
	set_height(new_height)
	var/determined_new_state
	switch(new_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			determined_new_state = LIQUID_STATE_FULLTILE
	if(determined_new_state != liquid_state)
		set_new_liquid_state(determined_new_state)

/obj/effect/abstract/liquid_turf/proc/set_height(new_height)
	var/prev_height = height
	height = new_height
	if(abs(height - prev_height) > WATER_HEIGH_DIFFERENCE_DELTA_SPLASH)
		//Splash
		if(prob(WATER_HEIGH_DIFFERENCE_SOUND_CHANCE))
			playsound(my_turf, PICK_WATER_WADE_NOISES, 60, 0)
		var/obj/splashy = new /obj/effect/temp_visual/liquid_splash(my_turf)
		splashy.color = color
		if(height >= LIQUID_WAIST_LEVEL_HEIGHT)
			//Push things into some direction, like space wind
			var/turf/dest_turf
			var/last_height = height
			for(var/turf in my_turf.atmos_adjacent_turfs)
				var/turf/T = turf
				if(T.z != my_turf.z)
					continue
				if(!T.liquids) //Automatic winner
					dest_turf = T
					break
				if(T.liquids.height < last_height)
					dest_turf = T
					last_height = T.liquids.height
			if(dest_turf)
				var/dir = get_dir(my_turf, dest_turf)
				var/atom/movable/AM
				for(var/thing in my_turf)
					AM = thing
					if(!AM.anchored && !AM.pulledby)
						if(iscarbon(AM))
							var/mob/living/carbon/C = AM
							if(!(C.shoes && C.shoes.clothing_flags & NOSLIP))
								step(C, dir)
								if(prob(60) && C.body_position != LYING_DOWN)
									to_chat(C, "<span class='userdanger'>The current knocks you down!</span>")
									C.Paralyze(60)
						else
							step(AM, dir)

/obj/effect/abstract/liquid_turf/immutable/set_height(new_height)
	height = new_height

/obj/effect/abstract/liquid_turf/proc/movable_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	var/turf/T = source
	if(liquid_state >= LIQUID_STATE_ANKLES)
		if(prob(30))
			playsound(T, PICK_WATER_WADE_NOISES, 50, 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			C.apply_status_effect(/datum/status_effect/water_affected)
	else if (isliving(AM))
		var/mob/living/L = AM
		if(prob(4) && !(L.movement_type & FLYING))
			L.slip(60, T, NO_SLIP_WHEN_WALKING, 20, TRUE)

/obj/effect/abstract/liquid_turf/proc/mob_fall(datum/source, mob/M)
	var/turf/T = source
	if(liquid_state >= LIQUID_STATE_ANKLES && T.has_gravity(T))
		playsound(T, 'sound/effects/liquids/splash.ogg', 50, 0)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.wear_mask && C.wear_mask.flags_cover & MASKCOVERSMOUTH)
				to_chat(C, "<span class='userdanger'>You fall in the water!</span>")
			else
				var/datum/reagents/tempr = take_reagents_flat(CHOKE_REAGENTS_INGEST_ON_FALL_AMOUNT)
				tempr.trans_to(C, tempr.total_volume, methods = INGEST)
				qdel(tempr)
				C.adjustOxyLoss(5)
				C.emote("cough")
				to_chat(C, "<span class='userdanger'>You fall in and swallow some water!</span>")
		else
			to_chat(M, "<span class='userdanger'>You fall in the water!</span>")

/obj/effect/abstract/liquid_turf/Initialize()
	if(!SSliquids)
		CRASH("Liquid Turf created with the liquids sybsystem not yet initialized!")
	. = ..()
	if(!immutable)
		my_turf = loc
		RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, .proc/movable_entered)
		RegisterSignal(my_turf, COMSIG_TURF_MOB_FALL, .proc/mob_fall)
		SSliquids.add_active_turf(my_turf)

		SEND_SIGNAL(my_turf, COMSIG_TURF_LIQUIDS_CREATION, src)

	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

	/* //Cant do it immediately, hmhm
	if(isspaceturf(my_turf))
		qdel(src, TRUE)
	*/

/obj/effect/abstract/liquid_turf/Destroy(force)
	if(force)
		UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_MOB_FALL))
		if(my_turf.lgroup)
			my_turf.lgroup.remove_from_group(my_turf)
		if(SSliquids.evaporation_queue[my_turf])
			SSliquids.evaporation_queue -= my_turf
		//Is added because it could invoke a change to neighboring liquids
		SSliquids.add_active_turf(my_turf)
		my_turf.liquids = null
		my_turf = null
		QUEUE_SMOOTH_NEIGHBORS(src)
		return ..()
	else
		return QDEL_HINT_LETMELIVE

/obj/effect/abstract/liquid_turf/immutable/Destroy(force)
	if(force)
		stack_trace("Something tried to hard destroy an immutable liquid.")
	return QDEL_HINT_LETMELIVE

//Exposes my turf with simulated reagents
/obj/effect/abstract/liquid_turf/proc/ExposeMyTurf()
	var/datum/reagents/tempr = simulate_reagents_threshold(LIQUID_REAGENT_THRESHOLD_TURF_EXPOSURE)
	tempr.expose(my_turf, TOUCH, tempr.total_volume)
	qdel(tempr)

/obj/effect/abstract/liquid_turf/proc/ChangeToNewTurf(turf/NewT)
	if(NewT.liquids)
		stack_trace("Liquids tried to change to a new turf, that already had liquids on it!")

	UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_MOB_FALL))
	if(SSliquids.active_turfs[my_turf])
		SSliquids.active_turfs -= my_turf
		SSliquids.active_turfs[NewT] = TRUE
	if(SSliquids.evaporation_queue[my_turf])
		SSliquids.evaporation_queue -= my_turf
		SSliquids.evaporation_queue[NewT] = TRUE
	my_turf.liquids = null
	my_turf = NewT
	NewT.liquids = src
	loc = NewT
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, .proc/movable_entered)
	RegisterSignal(my_turf, COMSIG_TURF_MOB_FALL, .proc/mob_fall)

/obj/effect/temp_visual/liquid_splash
	icon = 'icons/effects/splash.dmi'
	icon_state = "splash"
	layer = FLY_LAYER
	randomdir = FALSE

/***************************************************/
/********************PROPER GROUPING**************/

//Whenever you add a liquid cell add its contents to the group, have the group hold the reference to total reagents for processing sake
//Have the liquid turfs point to a partial liquids reference in the group for any interactions
//Have the liquid group handle the total reagents datum, and reactions too (apply fraction?)

GLOBAL_VAR_INIT(liquid_debug_colors, FALSE)

/datum/liquid_group
	var/list/members = list()
	var/color
	var/next_share = 0
	var/dirty = TRUE
	var/amount_of_active_turfs = 0
	var/decay_counter = 0
	var/expected_turf_height = 0
	var/cached_color
	var/list/last_cached_fraction_share
	var/last_cached_total_volume = 0
	var/last_cached_thermal = 0
	var/last_cached_overlay_state = LIQUID_STATE_PUDDLE

/datum/liquid_group/proc/add_to_group(turf/T)
	members[T] = TRUE
	T.lgroup = src
	if(SSliquids.active_turfs[T])
		amount_of_active_turfs++
	if(T.liquids)
		T.liquids.has_cached_share = FALSE

/datum/liquid_group/proc/remove_from_group(turf/T)
	members -= T
	T.lgroup = null
	if(SSliquids.active_turfs[T])
		amount_of_active_turfs--
	if(!members.len)
		qdel(src)

/datum/liquid_group/New(height)
	SSliquids.active_groups[src] = TRUE
	color = "#[random_short_color()]"
	expected_turf_height = height

/datum/liquid_group/proc/can_merge_group(datum/liquid_group/otherg)
	if(expected_turf_height == otherg.expected_turf_height)
		return TRUE
	return FALSE

/datum/liquid_group/proc/merge_group(datum/liquid_group/otherg)
	amount_of_active_turfs += otherg.amount_of_active_turfs
	for(var/t in otherg.members)
		var/turf/T = t
		T.lgroup = src
		members[T] = TRUE
		if(T.liquids)
			T.liquids.has_cached_share = FALSE
	otherg.members = list()
	qdel(otherg)
	share()

/datum/liquid_group/proc/break_group()
	//Flag puddles to the evaporation queue
	for(var/t in members)
		var/turf/T = t
		if(T.liquids && T.liquids.liquid_state >= LIQUID_STATE_PUDDLE)
			SSliquids.evaporation_queue[T] = TRUE

	share(TRUE)
	qdel(src)

/datum/liquid_group/Destroy()
	SSliquids.active_groups -= src
	for(var/t in members)
		var/turf/T = t
		T.lgroup = null
	members = null
	return ..()

/datum/liquid_group/proc/check_adjacency(turf/T)
	var/list/recursive_adjacent = list()
	var/list/current_adjacent = list()
	current_adjacent[T] = TRUE
	recursive_adjacent[T] = TRUE
	var/getting_new_turfs = TRUE
	var/indef_loop_safety = 0
	while(getting_new_turfs && indef_loop_safety < LIQUID_RECURSIVE_LOOP_SAFETY)
		indef_loop_safety++
		getting_new_turfs = FALSE
		var/list/new_adjacent = list()
		for(var/t in current_adjacent)
			var/turf/T2 = t
			for(var/y in T2.GetAtmosAdjacentTurfs())
				if(!recursive_adjacent[y])
					new_adjacent[y] = TRUE
					recursive_adjacent[y] = TRUE
					getting_new_turfs = TRUE
		current_adjacent = new_adjacent
	//All adjacent, somehow
	if(recursive_adjacent.len == members.len)
		return
	var/datum/liquid_group/new_group = new(expected_turf_height)
	for(var/t in members)
		if(!recursive_adjacent[t])
			remove_from_group(t)
			new_group.add_to_group(t)

/datum/liquid_group/proc/share(use_liquids_color = FALSE)
	var/any_share = FALSE
	var/cached_shares = 0
	var/list/cached_add = list()
	var/cached_volume = 0
	var/cached_thermal = 0

	var/turf/T
	var/obj/effect/abstract/liquid_turf/cached_liquids
	for(var/t in members)
		T = t
		if(T.liquids)
			any_share = TRUE
			cached_liquids = T.liquids

			if(cached_liquids.has_cached_share && last_cached_fraction_share)
				cached_shares++
				continue

			for(var/r_type in cached_liquids.reagent_list)
				if(!cached_add[r_type])
					cached_add[r_type] = 0
				cached_add[r_type] += cached_liquids.reagent_list[r_type]
			cached_volume += cached_liquids.total_reagents
			cached_thermal += cached_liquids.total_reagents * cached_liquids.temp
	if(!any_share)
		return

	decay_counter = 0

	if(cached_shares)
		for(var/reagent_type in last_cached_fraction_share)
			if(!cached_add[reagent_type])
				cached_add[reagent_type] = 0
			cached_add[reagent_type] += last_cached_fraction_share[reagent_type] * cached_shares
		cached_volume += last_cached_total_volume * cached_shares
		cached_thermal += cached_shares * last_cached_thermal

	for(var/reagent_type in cached_add)
		cached_add[reagent_type] = cached_add[reagent_type] / members.len
	cached_volume = cached_volume / members.len
	cached_thermal = cached_thermal / members.len
	var/temp_to_set = cached_thermal / cached_volume
	last_cached_thermal = cached_thermal
	last_cached_fraction_share = cached_add
	last_cached_total_volume = cached_volume
	var/mixed_color = use_liquids_color ? mix_color_from_reagent_list(cached_add) : color
	if(use_liquids_color)
		mixed_color = mix_color_from_reagent_list(cached_add)
	else if (GLOB.liquid_debug_colors)
		mixed_color = color
	else
		if(!cached_color)
			cached_color = mix_color_from_reagent_list(cached_add)
		mixed_color = cached_color

	var/height = CEILING(cached_volume/LIQUID_HEIGHT_DIVISOR, 1)

	var/determined_new_state
	var/state_height = height
	if(expected_turf_height > 0)
		state_height += expected_turf_height
	switch(state_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			determined_new_state = LIQUID_STATE_FULLTILE

	var/new_liquids = FALSE
	for(var/t in members)
		T = t
		new_liquids = FALSE
		if(!T.liquids)
			new_liquids = TRUE
			T.liquids = new(T)
		cached_liquids = T.liquids

		cached_liquids.reagent_list = cached_add.Copy()
		cached_liquids.total_reagents = cached_volume
		cached_liquids.temp = temp_to_set

		cached_liquids.has_cached_share = TRUE
		cached_liquids.attrition = 0

		cached_liquids.color = mixed_color
		cached_liquids.set_height(height)

		if(determined_new_state != cached_liquids.liquid_state)
			cached_liquids.set_new_liquid_state(determined_new_state)

		//Only simulate a turf exposure when we had to create a new liquid tile
		if(new_liquids)
			cached_liquids.ExposeMyTurf()

/datum/liquid_group/proc/process_cell(turf/T)
	if(T.liquids.height <= 1) //Causes a bug when the liquid hangs in the air and is supposed to fall down a level
		return FALSE
	for(var/tur in T.GetAtmosAdjacentTurfs())
		var/turf/T2 = tur
		//Immutable check thing
		if(T2.liquids && T2.liquids.immutable)
			if(T.z != T2.z)
				var/turf/Z_turf_below = T.below()
				if(T2 == Z_turf_below)
					qdel(T.liquids, TRUE)
					return
				else
					continue

			//CHECK DIFFERENT TURF HEIGHT THING
			if(T.liquid_height != T2.liquid_height)
				var/my_liquid_height = T.liquid_height + T.liquids.height
				var/target_liquid_height = T2.liquid_height + T2.liquids.height
				if(my_liquid_height > target_liquid_height+2)
					var/coeff = (T.liquids.height / (T.liquids.height + abs(T.liquid_height)))
					var/height_diff = min(0.4,abs((target_liquid_height / my_liquid_height)-1)*coeff)
					T.liquid_fraction_delete(height_diff)
					. = TRUE
				continue

			if(T2.liquids.height > T.liquids.height + 1)
				SSliquids.active_immutables[T2] = TRUE
				. = TRUE
				continue
		//END OF IMMUTABLE MADNESS

		if(T.z != T2.z)
			var/turf/Z_turf_below = T.below()
			if(T2 == Z_turf_below)
				if(!(T2.liquids && T2.liquids.height + T2.liquid_height >= LIQUID_HEIGHT_CONSIDER_FULL_TILE))
					T.liquid_fraction_share(T2, 1)
					qdel(T.liquids, TRUE)
					. = TRUE
			continue
		//CHECK DIFFERENT TURF HEIGHT THING
		if(T.liquid_height != T2.liquid_height)
			var/my_liquid_height = T.liquid_height + T.liquids.height
			var/target_liquid_height = T2.liquid_height + (T2.liquids ? T2.liquids.height : 0)
			if(my_liquid_height > target_liquid_height+1)
				var/coeff = (T.liquids.height / (T.liquids.height + abs(T.liquid_height)))
				var/height_diff = min(0.4,abs((target_liquid_height / my_liquid_height)-1)*coeff)
				T.liquid_fraction_share(T2, height_diff)
				. = TRUE
			continue
		//END OF TURF HEIGHT
		if(!T.can_share_liquids_with(T2))
			continue
		if(!T2.lgroup)
			add_to_group(T2)
		//Try merge groups if possible
		else if(T2.lgroup != T.lgroup && T.lgroup.can_merge_group(T2.lgroup))
			T.lgroup.merge_group(T2.lgroup)
		. = TRUE
		SSliquids.add_active_turf(T2)
	if(.)
		dirty = TRUE
			//return //Do we want it to spread once per process or many times?
	//Make sure to handle up/down z levels on adjacency properly

/turf
	var/datum/liquid_group/lgroup

/turf/proc/can_share_liquids_with(turf/T)
	if(T.z != z) //No Z here handling currently
		return FALSE
	/*
	if(T.lgroup && T.lgroup != lgroup) //TEMPORARY@!!!!!!!!
		return FALSE
	*/
	if(T.liquids && T.liquids.immutable)
		return FALSE

	var/my_liquid_height = liquids ? liquids.height : 0
	if(my_liquid_height < 1)
		return FALSE
	var/target_height = T.liquids ? T.liquids.height : 0

	//Varied heights handling:
	if(liquid_height != T.liquid_height)
		if(my_liquid_height+liquid_height < target_height + T.liquid_height + 1)
			return FALSE
		else
			return TRUE

	var/difference = abs(target_height - my_liquid_height)
	//The: sand effect or "piling" Very good for performance
	if(difference > 1) //SHOULD BE >= 1 or > 1? '>= 1' can lead into a lot of unnessecary processes, while ' > 1' will lead to a "piling" phenomena
		return TRUE
	return FALSE

/turf/proc/process_liquid_cell()
	if(!liquids)
		if(!lgroup)
			for(var/tur in GetAtmosAdjacentTurfs())
				var/turf/T2 = tur
				if(T2.liquids)
					if(T2.liquids.immutable)
						SSliquids.active_immutables[T2] = TRUE
					else if (T2.can_share_liquids_with(src))
						if(T2.lgroup)
							lgroup = new(liquid_height)
							lgroup.add_to_group(src)
						SSliquids.add_active_turf(T2)
						SSliquids.remove_active_turf(src)
						break
		SSliquids.remove_active_turf(src)
		return
	if(!lgroup)
		lgroup = new(liquid_height)
		lgroup.add_to_group(src)
	var/shared = lgroup.process_cell(src)
	if(QDELETED(liquids)) //Liquids may be deleted in process cell
		SSliquids.remove_active_turf(src)
		return
	if(!shared)
		liquids.attrition++
	if(liquids.attrition >= LIQUID_ATTRITION_TO_STOP_ACTIVITY)
		SSliquids.remove_active_turf(src)

/***************************************************/

/obj/effect/abstract/liquid_turf/immutable
	immutable = TRUE
	var/list/starting_mixture = list(/datum/reagent/water = 600)
	var/starting_temp = T20C

//STRICTLY FOR IMMUTABLES DESPITE NOT BEING /immutable
/obj/effect/abstract/liquid_turf/proc/add_turf(turf/T)
	T.liquids = src
	T.vis_contents += src
	SSliquids.active_immutables[T] = TRUE
	RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/movable_entered)
	RegisterSignal(T, COMSIG_TURF_MOB_FALL, .proc/mob_fall)

/obj/effect/abstract/liquid_turf/proc/remove_turf(turf/T)
	SSliquids.active_immutables -= T
	T.liquids = null
	T.vis_contents -= src
	UnregisterSignal(T, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_MOB_FALL))

/obj/effect/abstract/liquid_turf/immutable/ocean
	smoothing_flags = NONE
	icon_state = "ocean"
	base_icon_state = "ocean"
	plane = BLACKNESS_PLANE //Same as weather, etc.
	layer = ABOVE_MOB_LAYER
	starting_temp = T20C-150
	no_effects = TRUE
	vis_flags = NONE

/obj/effect/abstract/liquid_turf/immutable/ocean/warm
	starting_temp = T20C+20

/obj/effect/abstract/liquid_turf/immutable/Initialize()
	..()
	reagent_list = starting_mixture.Copy()
	total_reagents = 0
	for(var/key in reagent_list)
		total_reagents += reagent_list[key]
	temp = starting_temp
	calculate_height()
	set_reagent_color_for_liquid()

/turf/proc/process_immutable_liquid()
	var/any_share = FALSE
	for(var/tur in GetAtmosAdjacentTurfs())
		var/turf/T = tur
		if(can_share_liquids_with(T))
			//Move this elsewhere sometime later?
			if(T.liquids && T.liquids.height > liquids.height)
				continue

			any_share = TRUE
			T.add_liquid_list(liquids.reagent_list, TRUE, liquids.temp)
	if(!any_share)
		SSliquids.active_immutables -= src

/datum/status_effect/water_affected
	id = "wateraffected"
	alert_type = null
	duration = -1

/datum/status_effect/water_affected/on_apply()
	//We should be inside a liquid turf if this is applied
	calculate_water_slow()
	return TRUE

/datum/status_effect/water_affected/proc/calculate_water_slow()
	//Factor in swimming skill here?
	var/turf/T = get_turf(owner)
	var/slowdown_amount = T.liquids.liquid_state * 0.5
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/status_effect/water_slowdown, multiplicative_slowdown = slowdown_amount)

/datum/status_effect/water_affected/tick()
	var/turf/T = get_turf(owner)
	if(!T || !T.liquids || T.liquids.liquid_state == LIQUID_STATE_PUDDLE)
		qdel(src)
		return
	calculate_water_slow()
	//Make the reagents touch the person
	var/fraction = SUBMERGEMENT_PERCENT(owner, T.liquids)
	var/datum/reagents/tempr = T.liquids.simulate_reagents_flat(SUBMERGEMENT_REAGENTS_TOUCH_AMOUNT*fraction)
	tempr.expose(owner, TOUCH)
	qdel(tempr)
	return ..()

/datum/status_effect/water_affected/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/water_slowdown)

/datum/movespeed_modifier/status_effect/water_slowdown
	variable = TRUE
	blacklisted_movetypes = (FLYING|FLOATING)

/client/proc/toggle_liquid_debug()
	set category = "Debug"
	set name = "Liquid Groups Color Debug"
	set desc = "Liquid Groups Color Debug."
	if(!holder)
		return
	GLOB.liquid_debug_colors = !GLOB.liquid_debug_colors
