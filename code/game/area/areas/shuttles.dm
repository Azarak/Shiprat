
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NO_ALERTS
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM


/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Multi-area shuttles////////////////////////////

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/syndicate
	name = "Syndicate Infiltrator"
	main_ambience = AMBIENCE_DANGER
	area_limited_icon_smoothing = /area/shuttle/syndicate

/area/shuttle/syndicate/bridge
	name = "Syndicate Infiltrator Control"

/area/shuttle/syndicate/medical
	name = "Syndicate Infiltrator Medbay"

/area/shuttle/syndicate/armory
	name = "Syndicate Infiltrator Armory"

/area/shuttle/syndicate/eva
	name = "Syndicate Infiltrator EVA"

/area/shuttle/syndicate/hallway

/area/shuttle/syndicate/airlock
	name = "Syndicate Infiltrator Airlock"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "Pirate Shuttle"
	requires_power = TRUE

/area/shuttle/pirate/flying_dutchman
	name = "Flying Dutchman"
	requires_power = FALSE

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "Abandoned Ship"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "Abandoned Ship Bridge"

/area/shuttle/abandoned/engine
	name = "Abandoned Ship Engine"

/area/shuttle/abandoned/bar
	name = "Abandoned Ship Bar"

/area/shuttle/abandoned/crew
	name = "Abandoned Ship Crew Quarters"

/area/shuttle/abandoned/cargo
	name = "Abandoned Ship Cargo Bay"

/area/shuttle/abandoned/medbay
	name = "Abandoned Ship Medbay"

/area/shuttle/abandoned/pod
	name = "Abandoned Ship Pod"

////////////////////////////Single-area shuttles////////////////////////////
/area/shuttle/transit
	name = "Hyperspace"
	desc = "Weeeeee"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED


/area/shuttle/arrival
	name = "Arrival Shuttle"
	area_flags = UNIQUE_AREA// SSjob refers to this area for latejoiners


/area/shuttle/arrival/on_joining_game(mob/living/boarder)
	if(SSshuttle.arrivals?.mode == SHUTTLE_CALL)
		var/atom/movable/screen/splash/Spl = new(boarder.client, TRUE)
		Spl.Fade(TRUE)
	boarder.update_parallax_teleport()


/area/shuttle/pod_1
	name = "Escape Pod One"
	area_flags = NONE

/area/shuttle/pod_2
	name = "Escape Pod Two"
	area_flags = NONE

/area/shuttle/pod_3
	name = "Escape Pod Three"
	area_flags = NONE

/area/shuttle/pod_4
	name = "Escape Pod Four"
	area_flags = NONE

/area/shuttle/mining
	name = "Mining Shuttle"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS

/area/shuttle/mining/large
	name = "Mining Shuttle"
	requires_power = TRUE

/area/shuttle/common/vista
	name = "CPCV Vista"
	requires_power = TRUE

/area/shuttle/common/vista/helm
	name = "CPCV Vista Helm"

/area/shuttle/labor
	name = "Labor Camp Shuttle"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS

/area/shuttle/supply
	name = "Supply Shuttle"
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "Emergency Shuttle"
	area_flags = BLOBS_ALLOWED
	area_limited_icon_smoothing = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1
	area_flags = NO_ALERTS | CULT_PERMITTED

/area/shuttle/escape/backup
	name = "Backup Emergency Shuttle"

/area/shuttle/escape/brig
	name = "Escape Shuttle Brig"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "Luxurious Emergency Shuttle"
	area_flags = NOTELEPORT

/area/shuttle/escape/arena
	name = "The Arena"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "\proper a meteor with engines strapped to it"
	luminosity = NONE

/area/shuttle/transport
	name = "Transport Shuttle"

/area/shuttle/assault_pod
	name = "Steel Rain"

/area/shuttle/sbc_starfury
	name = "SBC Starfury"

/area/shuttle/sbc_fighter1
	name = "SBC Fighter 1"

/area/shuttle/sbc_fighter2
	name = "SBC Fighter 2"

/area/shuttle/sbc_corvette
	name = "SBC corvette"

/area/shuttle/syndicate_scout
	name = "Syndicate Scout"

// ----------- Arena Shuttle
/area/shuttle_arena
	name = "arena"
	has_gravity = STANDARD_GRAVITY
	requires_power = FALSE

/obj/effect/forcefield/arena_shuttle
	name = "portal"
	timeleft = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle/Initialize()
	. = ..()
	for(var/obj/effect/landmark/shuttle_arena_safe/exit in GLOB.landmarks_list)
		warp_points += exit

/obj/effect/forcefield/arena_shuttle/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if(L.pulling && istype(L.pulling, /obj/item/bodypart/head))
		to_chat(L, SPAN_NOTICE("Your offering is accepted. You may pass."), confidential = TRUE)
		qdel(L.pulling)
		var/turf/LA = get_turf(pick(warp_points))
		L.forceMove(LA)
		L.hallucination = 0
		to_chat(L, "<span class='reallybig redtext'>The battle is won. Your bloodlust subsides.</span>", confidential = TRUE)
		for(var/obj/item/chainsaw/doomslayer/chainsaw in L)
			qdel(chainsaw)
		var/obj/item/skeleton_key/key = new(L)
		L.put_in_hands(key)
	else
		to_chat(L, SPAN_WARNING("You are not yet worthy of passing. Drag a severed head to the barrier to be allowed entry to the hall of champions."), confidential = TRUE)

/obj/effect/landmark/shuttle_arena_safe
	name = "hall of champions"
	desc = "For the winners."

/obj/effect/landmark/shuttle_arena_entrance
	name = "\proper the arena"
	desc = "A lava filled battlefield."

/obj/effect/forcefield/arena_shuttle_entrance
	name = "portal"
	timeleft = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle_entrance/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	if(!warp_points.len)
		for(var/obj/effect/landmark/shuttle_arena_entrance/S in GLOB.landmarks_list)
			warp_points |= S

	var/obj/effect/landmark/LA = pick(warp_points)
	var/mob/living/M = AM
	M.forceMove(get_turf(LA))
	to_chat(M, "<span class='reallybig redtext'>You're trapped in a deadly arena! To escape, you'll need to drag a severed head to the escape portals.</span>", confidential = TRUE)
	M.apply_status_effect(STATUS_EFFECT_MAYHEM)

//Exploration shuttles

/area/shuttle/crow
	name = "ESS Crow"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/crow

/area/shuttle/crow/cargo
	name = "ESS Crow Cargo Bay"

/area/shuttle/crow/engineering
	name = "ESS Crow Engineering"

/area/shuttle/crow/helm
	name = "ESS Crow Helm"

//Common shuttles

/area/shuttle/platform
	name = "Platform Shuttle"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/platform

/area/shuttle/vulture
	name = "MS Vulture"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/vulture

/area/shuttle/vulture/helm
	name = "MS Vulture Helm"

/area/shuttle/vulture/dorm
	name = "MS Vulture Quarters"

/area/shuttle/petrel
	name = "MS Petrel"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/petrel

/area/shuttle/pigeon
	name = "CTS Pigeon"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/pigeon

/area/shuttle/pigeon/helm
	name = "CTS Pigeon Helm"

/area/shuttle/rockdove
	name = "EMS Rockdove"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/rockdove

/area/shuttle/rockdove/helm
	name = "EMS Rockdove Helm"

/area/shuttle/barrow
	name = "The Barrows"
	requires_power = FALSE
	area_limited_icon_smoothing = /area/shuttle/barrow

/area/shuttle/barrow/helm
	name = "The Barrows Helm"

/area/shuttle/barrow/medbay
	name = "The Barrows Medbay"

/area/shuttle/barrow/bar
	name = "The Barrows Bar"

/area/shuttle/chilldown
	name = "The Chilldown"
	requires_power = FALSE
	area_limited_icon_smoothing = /area/shuttle/chilldown

/area/shuttle/ironwrought
	name = "The Ironwrought"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/ironwrought

/area/shuttle/ironwrought/engine
	name = "The Ironwrought Core"

