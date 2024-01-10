/datum/map_config/hubstation
	map_name = "Hub Station"
	map_path = "map_files/hubstation"
	map_file = "hubstation_merged.dmm"

	traits = list(
		list(
			"Up" = 1,
		),
		list(
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
		)
	)

	allow_custom_shuttles = TRUE
	shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"emergency" = "emergency_box",
	)

	job_changes = list()

	overmap_object_type = /datum/overmap_object/shuttle/station
