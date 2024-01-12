/datum/base_map_generator

/datum/base_map_generator/proc/generate(datum/map_zone/mapzone)
	return

/datum/base_map_generator/load_file
	var/map_path = ""
	var/list/map_files = list()
	var/list/traits = list()
	var/self_looping = FALSE
	var/map_margin = MAP_EDGE_PAD
	var/size_x = 255
	var/size_y = 255
	var/allocation_type = ALLOCATION_FULL

/datum/base_map_generator/load_file/generate(datum/map_zone/mapzone)
	var/list/errorList = list()
	// check that the total z count of all maps matches the list of traits
	var/total_levels = 0
	var/list/parsed_maps = list()
	for (var/file in map_files)
		var/full_path = "_maps/[map_path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_levels  // save the start Z of this file
		total_levels += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if(total_levels != traits.len)  // mismatch
		log_world("WARNING: [traits.len] trait sets specified for [total_levels] z-levels in [map_path]!")
		return

	// preload the relevant space_level datums
	var/list/ordered_vlevels = list()
	for(var/i in 1 to traits.len)
		var/list/level = traits[i]
		var/level_name = "[mapzone.name] [i]"
		var/datum/virtual_level/vlevel = SSmapping.create_virtual_level(level_name, level.Copy(), mapzone, size_x, size_y, allocation_type, reservation_margin = map_margin)
		ordered_vlevels += vlevel

	mapzone.vlevel_trait_init()

	// load the maps
	var/i = 0
	for (var/P in parsed_maps)
		i++
		var/datum/virtual_level/vlevel = ordered_vlevels[i]
		var/datum/parsed_map/pm = P
		if (!pm.load(vlevel.low_x, vlevel.low_y, vlevel.z_value, no_changeturf = TRUE))
			errorList |= pm.original_path

	for(var/datum/virtual_level/vlevel as anything in ordered_vlevels)
		if(self_looping)
			vlevel.selfloop()

/datum/base_map_generator/empty_levels
	var/level_amount = 1
	var/turf_type = null
	var/area_type = null
	var/list/traits = list()
	var/self_looping = FALSE
	var/map_margin = MAP_EDGE_PAD
	var/size_x = 255
	var/size_y = 255
	var/allocation_type = ALLOCATION_FULL

/datum/base_map_generator/empty_levels/generate(datum/map_zone/mapzone)
	var/list/vlevels = list()
	for(var/i in 1 to level_amount)
		var/datum/virtual_level/vlevel = SSmapping.create_virtual_level("[mapzone.name] [i]", traits[i], mapzone, size_x, size_y, allocation_type)
		if(map_margin)
			vlevel.reserve_margin(map_margin)
		if(self_looping)
			vlevel.selfloop()
		vlevels += vlevel
	mapzone.vlevel_trait_init()
	for(var/datum/virtual_level/vlevel as anything in vlevels)
		if(!isnull(area_type))
			var/list/turfs = vlevel.get_block()
			var/area/new_area = new area_type()
			new_area.contents.Add(turfs)
		if(!isnull(turf_type))
			var/list/turfs = vlevel.get_unreserved_block()
			for(var/turf/turf as anything in turfs)
				turf.ChangeTurf(turf_type, null, CHANGETURF_DEFER_CHANGE)
