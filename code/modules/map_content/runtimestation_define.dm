/datum/map_config/runtimestation
	map_name = "Runtime Station"

	shuttles = list(
		"cargo" = "cargo_delta"
	)

/datum/map_zone_generator/runtimestation
	mapzone_name = "Runtime Station"
	base_map_generator = /datum/base_map_generator/load_file/runtimestation

/datum/base_map_generator/load_file/runtimestation
	map_path = "map_files/debug"
	map_files = list("runtimestation.dmm")
	traits = list(
		list(
			"Station" = 1
		)
	)
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL
