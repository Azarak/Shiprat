/datum/round_event_control/pirates
	name = "Space Pirates"
	typepath = /datum/round_event/pirates
	weight = 8
	max_occurrences = 1
	min_players = 10
	earliest_start = 30 MINUTES

	track = EVENT_TRACK_ROLESET
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE)
	min_sec_crew = 1

#define PIRATES_ROGUES "Rogues"
#define PIRATES_SILVERSCALES "Silverscales"
#define PIRATES_DUTCHMAN "Flying Dutchman"

/datum/round_event/pirates
	startWhen = 60 //2 minutes to answer
	var/datum/comm_message/threat
	var/payoff = 0
	var/payoff_min = 20000
	var/paid_off = FALSE
	var/pirate_type
	var/ship_template
	var/ship_name = "Space Privateers Association"
	var/shuttle_spawned = FALSE

/datum/round_event/pirates/setup()
	pirate_type = pick(PIRATES_ROGUES, PIRATES_SILVERSCALES, PIRATES_DUTCHMAN)
	switch(pirate_type)
		if(PIRATES_ROGUES)
			ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))
		if(PIRATES_SILVERSCALES)
			ship_name = pick(strings(PIRATE_NAMES_FILE, "silverscale_names"))
		if(PIRATES_DUTCHMAN)
			ship_name = "Flying Dutchman"

/datum/round_event/pirates/announce(fake)
	priority_announce("Incoming subspace communication. Secure channel opened at all communication consoles.", "Incoming Message", SSstation.announcer.get_rand_report_sound())
	if(fake)
		return
	threat = new
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
	if(D)
		payoff = max(payoff_min, FLOOR(D.account_balance * 0.80, 1000))
	switch(pirate_type)
		if(PIRATES_ROGUES)
			ship_template = /datum/map_template/shuttle/pirate/default
			threat.title = "Sector protection offer"
			threat.content = "Hey, pal, this is the [ship_name]. Can't help but notice you're rocking a wild and crazy shuttle there with NO INSURANCE! Crazy. What if something happened to it, huh?! We've done a quick evaluation on your rates in this sector and we're offering [payoff] to cover for your shuttle in case of any disaster."
			threat.possible_answers = list("Purchase Insurance.","Reject Offer.")
		if(PIRATES_SILVERSCALES)
			ship_template = /datum/map_template/shuttle/pirate/silverscale
			threat.title = "Tribute to high society"
			threat.content = "This is the [ship_name]. The Silver Scales wish for some tribute from your plebeian lizards. [payoff] credits should do the trick."
			threat.possible_answers = list("We'll pay.","Tribute? Really? Go away.")
		if(PIRATES_DUTCHMAN)
			ship_template = /datum/map_template/shuttle/pirate/dutchman
			threat.title = "Business proposition"
			threat.content = "Ahoy! This be the [ship_name]. Cough up [payoff] credits or you'll walk the plank."
			threat.possible_answers = list("We'll pay.","We will not be extorted.")
	threat.answer_callback = CALLBACK(src,.proc/answered)
	SScommunications.send_message(threat,unique = TRUE)

/datum/round_event/pirates/proc/answered()
	if(threat && threat.answered == 1)
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(D)
			if(D.adjust_money(-payoff))
				priority_announce("Thanks for the credits, landlubbers.",sender_override = ship_name)
				paid_off = TRUE
				return
			else
				priority_announce("Trying to cheat us? You'll regret this!",sender_override = ship_name)
	if(!shuttle_spawned)
		spawn_shuttle()
	else
		priority_announce("Too late to beg for mercy!",sender_override = ship_name)

/datum/round_event/pirates/start()
	if(threat && !threat.answered)
		threat.possible_answers = list("Too late")
		threat.answered = 1
	if(!paid_off && !shuttle_spawned)
		spawn_shuttle()

/datum/round_event/pirates/proc/spawn_shuttle()
	shuttle_spawned = TRUE

	var/list/candidates = pollGhostCandidates("Do you wish to be considered for pirate crew?", ROLE_TRAITOR)
	shuffle_inplace(candidates)

	var/datum/map_template/shuttle/pirate/ship = new ship_template

	var/obj/docking_port/mobile/loaded_ship = SSshuttle.action_load(ship)
	if(!loaded_ship)
		CRASH("Loading pirate ship failed!")

	var/list/shuttle_coords = loaded_ship.return_coords()

	for(var/turf/A in block(locate(shuttle_coords[1], shuttle_coords[2], loaded_ship.z), locate(shuttle_coords[3], shuttle_coords[4], loaded_ship.z)))
		for(var/obj/effect/mob_spawn/human/pirate/spawner in A)
			if(candidates.len > 0)
				var/mob/M = candidates[1]
				spawner.create(M.ckey)
				candidates -= M
				announce_to_ghosts(M)
			else
				announce_to_ghosts(spawner)

	priority_announce("Unidentified armed ship detected near the station.")

//Shuttle equipment

/obj/machinery/shuttle_scrambler
	name = "Data Siphon"
	desc = "This heap of machinery steals credits and data from unprotected systems and locks down cargo shuttles."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator"
	density = TRUE
	var/active = FALSE
	var/credits_stored = 0
	var/siphon_per_tick = 5

/obj/machinery/shuttle_scrambler/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/machinery/shuttle_scrambler/process()
	if(active)
		if(is_station_level(src))
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				var/siphoned = min(D.account_balance,siphon_per_tick)
				D.adjust_money(-siphoned)
				credits_stored += siphoned
			interrupt_research()
		else
			return
	else
		STOP_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/proc/toggle_on(mob/user)
	AddComponent(/datum/component/gps, "Nautical Signal")
	active = TRUE
	to_chat(user,SPAN_NOTICE("You toggle [src] [active ? "on":"off"]."))
	to_chat(user,SPAN_WARNING("The scrambling signal can be now tracked by GPS."))
	START_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/interact(mob/user)
	if(!active)
		if(tgui_alert(user, "Turning the scrambler on will make the shuttle trackable by GPS. Are you sure you want to do it?", "Scrambler", list("Yes", "Cancel")) == "Cancel")
			return
		if(active || !user.canUseTopic(src, BE_CLOSE))
			return
		toggle_on(user)
		update_appearance()
		send_notification()
	else
		dump_loot(user)

//interrupt_research
/obj/machinery/shuttle_scrambler/proc/interrupt_research()
	for(var/obj/machinery/rnd/server/S in GLOB.machines)
		if(S.machine_stat & (NOPOWER|BROKEN))
			continue
		S.emp_act(1)
		new /obj/effect/temp_visual/emp(get_turf(S))

/obj/machinery/shuttle_scrambler/proc/dump_loot(mob/user)
	if(credits_stored) // Prevents spamming empty holochips
		new /obj/item/holochip(drop_location(), credits_stored)
		to_chat(user,SPAN_NOTICE("You retrieve the siphoned credits!"))
		credits_stored = 0
	else
		to_chat(user,SPAN_NOTICE("There's nothing to withdraw."))

/obj/machinery/shuttle_scrambler/proc/send_notification()
	priority_announce("Data theft signal detected, source registered on local gps units.")

/obj/machinery/shuttle_scrambler/proc/toggle_off(mob/user)
	active = FALSE
	STOP_PROCESSING(SSobj,src)

/obj/machinery/shuttle_scrambler/update_icon_state()
	icon_state = active ? "dominator-Blue" : "dominator"
	return ..()

/obj/machinery/shuttle_scrambler/Destroy()
	toggle_off()
	return ..()

/obj/machinery/computer/shuttle/pirate
	name = "pirate shuttle console"
	shuttleId = "pirateship"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	possible_destinations = "pirateship_away;pirateship_home;pirateship_custom"

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/pirate
	name = "pirate shuttle navigation computer"
	desc = "Used to designate a precise transit location for the pirate shuttle."
	shuttleId = "pirateship"
	trait_lock = ZTRAIT_STATION
	shuttlePortId = "pirateship_custom"
	x_offset = 9
	y_offset = 0
	see_hidden = FALSE

/obj/docking_port/mobile/pirate
	name = "pirate shuttle"
	id = "pirateship"
	rechargeTime = 3 MINUTES

/obj/machinery/suit_storage_unit/pirate
	suit_type = /obj/item/clothing/suit/space
	helmet_type = /obj/item/clothing/head/helmet/space
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/tank/internals/oxygen

/obj/machinery/loot_locator
	name = "Booty Locator"
	desc = "This sophisticated machine scans the nearby space for items of value."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	density = TRUE
	var/cooldown = 300
	var/next_use = 0

/obj/machinery/loot_locator/interact(mob/user)
	if(world.time <= next_use)
		to_chat(user,SPAN_WARNING("[src] is recharging."))
		return
	next_use = world.time + cooldown
	var/atom/movable/AM = find_random_loot()
	if(!AM)
		say("No valuables located. Try again later.")
	else
		say("Located: [AM.name] at [get_area_name(AM)]")

/obj/machinery/loot_locator/proc/find_random_loot()
	return null
