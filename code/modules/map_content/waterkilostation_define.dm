/datum/map_config/waterkilostation
	map_name = "Water Kilo Station"
	map_path = "map_files/WaterKiloStation"
	map_file = list(
		"WaterKiloBelow.dmm",
		"WaterKiloStation.dmm",
	)

	traits = list(
		list(
			"Linkage" = null,
			"Up" = 1,
			"Gravity" = TRUE,
			"Ocean Ruins" = TRUE,
			"Ocean Station" = TRUE,
			"Baseturf" = "/turf/open/floor/plating/asteroid",
		),
		list(
			"Down" = -1,
			"Linkage" = null,
			"Gravity" = TRUE,
			"Trench Ruins" = TRUE,
			"Baseturf" = "/turf/open/floor/plating/asteroid"
		),
	)
	space_ruin_levels = 3

	minetype = "lavaland"

	allow_custom_shuttles = TRUE
	shuttles = list(
		"cargo" = "cargo_kilo",
		"ferry" = "ferry_kilo",
		"whiteship" = "whiteship_kilo",
		"emergency" = "emergency_kilo",
	)

	job_changes = list(
		"cook" = list(
			"additional_cqc_areas" = list("/area/service/bar/atrium"),
		),
		"captain" = list(
			"special_charter" = "asteroid",
		),
	)


	overmap_object_type = /datum/overmap_object/shuttle/planet/waterkilo
	atmosphere_type = /datum/atmosphere/waterkilo
	ore_node_seeder_type = /datum/ore_node_seeder

	banned_event_tags = list(TAG_SPACE)
