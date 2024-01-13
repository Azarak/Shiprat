SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/datum/map_config/config
	var/datum/map_config/next_map_config

	var/map_voted = FALSE

	var/list/map_templates = list()
	var/list/landing_pad_templates = list()

	var/list/ruins_templates = list()

	var/datum/space_level/isolated_ruins_z //Created on demand during ruin loading.

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()
	var/list/holodeck_templates = list()

	var/list/areas_in_z = list()

	var/loading_ruins = FALSE

	///All possible biomes in assoc list as type || instance
	var/list/biomes = list()

	// Z-manager stuff
	var/list/z_list
	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE


	/// The map zone of the main loaded station, for easy access
	var/datum/map_zone/station_map_zone
	/// The map zone to strand things at
	var/datum/map_zone/strand_map_zone
	/// The map zone to dock dead/abandoned transit ships at
	var/datum/map_zone/ship_graveyard_map_zone
	/// List of all map zones
	var/list/map_zones = list()
	/// Translation of virtual level ID to a virtual level reference
	var/list/virtual_z_translation = list()

/datum/controller/subsystem/mapping/New()
	..()
#ifdef FORCE_MAP
	config = load_map_config(FORCE_MAP)
#else
	config = load_map_config(error_if_missing = FALSE)
#endif

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(initialized)
		return
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, SPAN_BOLDANNOUNCE("Unable to load next or default map config, defaulting to Meta Station"))
			config = old_config
	initialize_biomes()
	preloadTemplates()
	loadWorld()
	pre_load_allocation_levels()
	repopulate_sorted_areas()
	process_teleport_locs() //Sets up the wizard teleport locations

	// Run map generation after ruin generation to prevent issues
	run_map_generation()

	repopulate_sorted_areas()
	generate_station_area_list()
	return ..()

/// Pre loads some allocation levels that are very likely to be used so they dont have to initalized on runtime. Completely fine if this didn't exist.
/datum/controller/subsystem/mapping/proc/pre_load_allocation_levels()
	add_new_zlevel("Free Allocation Level", allocation_type = ALLOCATION_FREE)

/datum/controller/subsystem/mapping/proc/safety_clear_transit_dock(obj/docking_port/stationary/transit/T, obj/docking_port/mobile/M, list/returning)
	M.setTimer(0)
	var/error = M.initiate_docking(M.destination, M.preferred_direction)
	if(!error)
		returning += M
		qdel(T, TRUE)

/* Nuke threats, for making the blue tiles on the station go RED
Used by the AI doomsday and the self-destruct nuke.
*/

/datum/controller/subsystem/mapping/proc/add_nuke_threat(datum/nuke)
	nuke_threats[nuke] = TRUE
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/remove_nuke_threat(datum/nuke)
	nuke_threats -= nuke
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/check_nuke_threats()
	for(var/datum/d in nuke_threats)
		if(!istype(d) || QDELETED(d))
			nuke_threats -= d

	for(var/N in nuke_tiles)
		var/turf/open/floor/circuit/C = N
		C.update_appearance()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	shuttle_templates = SSmapping.shuttle_templates
	shelter_templates = SSmapping.shelter_templates
	holodeck_templates = SSmapping.holodeck_templates

	config = SSmapping.config
	next_map_config = SSmapping.next_map_config

	z_list = SSmapping.z_list

#define INIT_ANNOUNCE(X) to_chat(world, SPAN_BOLDANNOUNCE("[X]")); log_world(X)

/datum/controller/subsystem/mapping/proc/loadWorld()
	// Ensure mapzone and virtual level wrap the Centcomm level
	InitializeDefaultZLevels()

	//Load overmap
	SSovermap.MappingInit()

	// load the station
	INIT_ANNOUNCE("Loading [config.map_name]...")
	var/station_overmap_object = new config.overmap_object_type(SSovermap.main_system, rand(3,10), rand(3,10))

	var/datum/map_zone_generator/gen = new config.map_zone_generator()
	var/datum/map_zone/generated_station_map_zone = gen.generate(station_overmap_object)
	station_map_zone = generated_station_map_zone

	if(SSdbcore.Connect())
		var/datum/db_query/query_round_map_name = SSdbcore.NewQuery({"
			UPDATE [format_table_name("round")] SET map_name = :map_name WHERE id = :round_id
		"}, list("map_name" = config.map_name, "round_id" = GLOB.round_id))
		query_round_map_name.Execute()
		qdel(query_round_map_name)

#ifndef LOWMEMORYMODE
	// TODO: remove this when the DB is prepared for the z-levels getting reordered
	//Load planets
	var/list/habitable_big_planets = list(
		/datum/overmap_map_zone_generator/lush,
		/datum/overmap_map_zone_generator/jungle,
		/datum/overmap_map_zone_generator/snow
		)
	var/list/smaller_levels_to_spawn = list(
		/datum/overmap_map_zone_generator/asteroid/quad,
		/datum/overmap_map_zone_generator/asteroid/quad,
		/datum/overmap_map_zone_generator/asteroid/quad,
		/datum/overmap_map_zone_generator/chlorine/quad,
		/datum/overmap_map_zone_generator/desert/quad,
		/datum/overmap_map_zone_generator/jungle/quad,
		/datum/overmap_map_zone_generator/lush/quad,
		/datum/overmap_map_zone_generator/snow/quad,
		/datum/overmap_map_zone_generator/volcanic/quad,
	)
	var/picked_big_planet = pick(habitable_big_planets)
	var/datum/overmap_map_zone_generator/big_gen = new picked_big_planet()
	big_gen.generate(SSovermap.main_system, rand(5,25), rand(5,25))

	for(var/generator_type in smaller_levels_to_spawn)
		var/datum/overmap_map_zone_generator/smaller_gen = new generator_type()
		smaller_gen.generate(SSovermap.main_system, rand(5,25), rand(5,25))
#endif
	var/datum/overmap_map_zone_generator/asteroid_gen = new /datum/overmap_map_zone_generator/asteroid()
	strand_map_zone = asteroid_gen.generate(SSovermap.main_system, rand(5,25), rand(5,25))

	var/datum/overmap_map_zone_generator/graveyard_gen = new /datum/overmap_map_zone_generator/ship_graveyard()
	ship_graveyard_map_zone = graveyard_gen.generate(SSovermap.main_system, rand(5,25), rand(5,25))
#undef INIT_ANNOUNCE


GLOBAL_LIST_EMPTY(the_station_areas)

/datum/controller/subsystem/mapping/proc/generate_station_area_list()
	var/list/station_areas_blacklist = typecacheof(list(/area/space, /area/mine, /area/ruin, /area/asteroid/nearstation))
	for(var/area/A in world)
		if (is_type_in_typecache(A, station_areas_blacklist))
			continue
		if (!A.contents.len || !(A.area_flags & UNIQUE_AREA))
			continue
		if (is_station_level(A))
			GLOB.the_station_areas += A.type

	if(!GLOB.the_station_areas.len)
		log_world("ERROR: Station areas list failed to generate!")

/datum/controller/subsystem/mapping/proc/run_map_generation()
	for(var/area/A in world)
		A.RunGeneration()

/datum/controller/subsystem/mapping/proc/maprotate()
	if(map_voted || SSmapping.next_map_config) //If voted or set by other means.
		return

	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	//count votes
	var/pmv = CONFIG_GET(flag/preference_map_voting)
	if(pmv)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote)
				if (global.config.defaultmap)
					mapvotes[global.config.defaultmap.map_name] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.maplist)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
			continue
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		if(map in SSpersistence.blocked_maps)
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		if(pmv)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (. && VM.map_name != config.map_name)
		to_chat(world, SPAN_BOLDANNOUNCE("Map rotation has chosen [VM.map_name] for next round!"))

/datum/controller/subsystem/mapping/proc/mapvote()
	if(map_voted || SSmapping.next_map_config) //If voted or set by other means.
		return
	if(SSvote.mode) //Theres already a vote running, default to rotation.
		maprotate()
	SSvote.initiate_vote("map", "automatic map rotation")

/datum/controller/subsystem/mapping/proc/changemap(datum/map_config/VM)
	if(!VM.MakeNextMap())
		next_map_config = load_map_config(default_to_box = TRUE)
		message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
		return

	next_map_config = VM
	return TRUE

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadLandingPadTemplates()
	preloadRuinTemplates()
	preloadShuttleTemplates()
	preloadShelterTemplates()
	preloadHolodeckTemplates()

/datum/controller/subsystem/mapping/proc/preloadLandingPadTemplates()
	for(var/path in subtypesof(/datum/map_template/ruin/landing_pad))
		var/datum/map_template/T = new path()
		landing_pad_templates[path] = T
		map_templates[T.name] = T

/datum/controller/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("[global.config.directory]/lavaruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/spaceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/iceruinblacklist.txt")

	for(var/item in sortList(subtypesof(/datum/map_template/ruin), /proc/cmp_ruincost_priority))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!initial(ruin_type.id))
			continue
		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

/datum/controller/subsystem/mapping/proc/preloadShuttleTemplates()
	var/list/unbuyable = generateMapList("[global.config.directory]/unbuyableshuttles.txt")

	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item
		if(!(initial(shuttle_type.suffix)))
			continue

		var/datum/map_template/shuttle/S = new shuttle_type()
		if(unbuyable.Find(S.mappath))
			S.who_can_purchase = null

		shuttle_templates[S.shuttle_id] = S
		map_templates[S.shuttle_id] = S

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
		map_templates[S.shelter_id] = S

/datum/controller/subsystem/mapping/proc/preloadHolodeckTemplates()
	for(var/item in subtypesof(/datum/map_template/holodeck))
		var/datum/map_template/holodeck/holodeck_type = item
		if(!(initial(holodeck_type.mappath)))
			continue
		var/datum/map_template/holodeck/holo_template = new holodeck_type()

		holodeck_templates[holo_template.template_id] = holo_template

//Manual loading of away missions.
/client/proc/admin_away()
	set name = "Load Away Mission"
	set category = "Admin.Events"

	if(!holder ||!check_rights(R_FUN))
		return


	if(!GLOB.the_gateway)
		if(tgui_alert(usr, "There's no home gateway on the station. You sure you want to continue ?", "Uh oh", list("Yes", "No")) != "Yes")
			return

	var/list/possible_options = GLOB.potentialRandomZlevels + "Custom"
	var/away_name
	var/datum/space_level/away_level

	var/answer = input("What kind ? ","Away") as null|anything in possible_options
	switch(answer)
		if("Custom")
			var/mapfile = input("Pick file:", "File") as null|file
			if(!mapfile)
				return
			away_name = "[mapfile] custom"
			to_chat(usr,SPAN_NOTICE("Loading [away_name]..."))
			var/datum/map_template/template = new(mapfile, "Away Mission")
			away_level = template.load_new_z()
		else
			if(answer in GLOB.potentialRandomZlevels)
				away_name = answer
				to_chat(usr,SPAN_NOTICE("Loading [away_name]..."))
				var/datum/map_template/template = new(away_name, "Away Mission")
				away_level = template.load_new_z()
			else
				return

	message_admins("Admin [key_name_admin(usr)] has loaded [away_name] away mission.")
	log_admin("Admin [key_name(usr)] has loaded [away_name] away mission.")
	if(!away_level)
		message_admins("Loading [away_name] failed!")
		return

///Initialize all biomes, assoc as type || instance
/datum/controller/subsystem/mapping/proc/initialize_biomes()
	for(var/biome_path in subtypesof(/datum/biome))
		var/datum/biome/biome_instance = new biome_path()
		biomes[biome_path] += biome_instance

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()

/datum/controller/subsystem/mapping/proc/get_map_zone_weather_controller(atom/Atom)
	var/datum/map_zone/mapzone = Atom.get_map_zone()
	if(!mapzone)
		return
	mapzone.assert_weather_controller()
	return mapzone.weather_controller

/datum/controller/subsystem/mapping/proc/get_map_zone_id(mapzone_id)
	var/datum/map_zone/returned_mapzone
	for(var/datum/map_zone/iterated_mapzone as anything in map_zones)
		if(iterated_mapzone.id == mapzone_id)
			returned_mapzone = iterated_mapzone
			break
	return returned_mapzone

/datum/controller/subsystem/mapping/proc/get_virtual_level_id(vlevel_id)
	return virtual_z_translation["[vlevel_id]"]

/// Searches for a free allocation for the passed type and size, creates new physical levels if nessecary.
/datum/controller/subsystem/mapping/proc/get_free_allocation(allocation_type, size_x, size_y, allocation_jump = DEFAULT_ALLOC_JUMP)
	var/list/allocation_list
	var/list/levels_to_check = z_list.Copy()
	var/created_new_level = FALSE
	while(TRUE)
		for(var/datum/space_level/iterated_level as anything in levels_to_check)
			if(iterated_level.allocation_type != allocation_type)
				continue
			allocation_list = find_allocation_in_level(iterated_level, size_x, size_y, allocation_jump)
			if(allocation_list)
				return allocation_list

		if(created_new_level)
			stack_trace("MAPPING: We have failed to find allocation after creating a new level just for it, something went terribly wrong")
			return FALSE
		/// None of the levels could faciliate a new allocation, make a new one
		created_new_level = TRUE
		levels_to_check.Cut()

		var/allocation_name
		switch(allocation_type)
			if(ALLOCATION_FREE)
				allocation_name = "Free Allocation"
			if(ALLOCATION_QUADRANT)
				allocation_name = "Quadrant Allocation"
			if(ALLOCATION_FULL)
				allocation_name = "Full Allocation"
			else
				allocation_name = "Unaccounted Allocation"

		levels_to_check += add_new_zlevel("Generated [allocation_name] Level", allocation_type = allocation_type)

/// Finds a box allocation inside a Z level. Uses a methodical box boundary check method
/datum/controller/subsystem/mapping/proc/find_allocation_in_level(datum/space_level/level, size_x, size_y, allocation_jump)
	var/target_x = 1
	var/target_y = 1

	/// Sanity
	if(size_x > world.maxx || size_y > world.maxy)
		stack_trace("Tried to find virtual level allocation that cannot possibly fit in a physical level.")
		return FALSE

	/// Methodical trial and error method
	while(TRUE)
		var/upper_target_x = target_x+size_x
		var/upper_target_y = target_y+size_y

		var/out_of_bounds = FALSE
		if((target_x < 1 || upper_target_x > world.maxx) || (target_y < 1 || upper_target_y > world.maxy))
			out_of_bounds = TRUE

		if(!out_of_bounds && level.is_box_free(target_x, target_y, upper_target_x, upper_target_y))
			return list(target_x, target_y, level.z_value) //hallelujah we found the unallocated spot

		if(upper_target_x > world.maxx) //If we can't increment x, then the search is over
			break

		var/increments_y = TRUE
		if(upper_target_y > world.maxy)
			target_y = 1
			increments_y = FALSE
		if(increments_y)
			target_y += allocation_jump
		else
			target_x += allocation_jump

/// Creates and passes a new map zone
/datum/controller/subsystem/mapping/proc/create_map_zone(new_name, datum/overmap_object/passed_ov_obj)
	return new /datum/map_zone(new_name, passed_ov_obj)

/// Allocates, creates and passes a new virtual level
/datum/controller/subsystem/mapping/proc/create_virtual_level(new_name, list/traits, datum/map_zone/mapzone, width, height, allocation_type = ALLOCATION_FREE, allocation_jump = DEFAULT_ALLOC_JUMP, reservation_margin = 0)
	/// Because we add an implicit extra 1 in the way we do reservation
	width--
	height--
	var/list/allocation_coords = SSmapping.get_free_allocation(allocation_type, width, height, allocation_jump)
	var/datum/virtual_level/vlevel = new /datum/virtual_level(new_name, traits, mapzone, allocation_coords[1], allocation_coords[2], allocation_coords[1] + width, allocation_coords[2] + height, allocation_coords[3])
	if(reservation_margin)
		vlevel.reserve_margin(reservation_margin)
	return vlevel
