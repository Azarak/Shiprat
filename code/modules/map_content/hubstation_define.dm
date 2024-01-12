/datum/map_config/hubstation
	map_name = "Hub Station"

	map_zone_generator = /datum/map_zone_generator/hubstation

	allow_custom_shuttles = TRUE
	shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"emergency" = "emergency_box",
	)
	job_changes = list()
	overmap_object_type = /datum/overmap_object/shuttle/station

/datum/map_zone_generator/hubstation
	mapzone_name = "Hub Station"
	base_map_generator = /datum/base_map_generator/load_file/hubstation
	terrain_generator = null
	ruin_generator = null
	pre_custom_generators = null
	post_custom_generators = null
	weather_controller = null
	day_night_controller = null
	atmosphere = null
	ore_node_seeder = null
	rock_color = null
	plant_color = null
	grass_color = null
	water_color = null

/datum/base_map_generator/load_file/hubstation
	map_path = "map_files/hubstation"
	map_files = list("hubstation_merged.dmm")
	traits = list(
		list(
			"Up" = 1,
			"Station" = 1
		),
		list(
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
			"Station" = 1
		)
	)
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL
