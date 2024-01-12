/datum/map_config/multizdebug
	map_name = "MultiZ Debug"

/datum/map_zone_generator/multizdebug
	mapzone_name = "MultiZ Debug"
	base_map_generator = /datum/base_map_generator/load_file/multizdebug

/datum/base_map_generator/load_file/multizdebug
	map_path = "map_files/debug"
	map_files = list("multiz.dmm")
	traits = list(
		list(
			"Up" = 1,
			"Station" = 1
		),
		list(
			"Up" = 1,
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
			"Station" = 1
		),
		list(
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
			"Station" = 1
		),
	)
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL
