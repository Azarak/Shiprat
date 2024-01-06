/datum/map_config/hubstation
	map_name = "Hub Station"
	map_path = "map_files/hubstation"
	map_file = "hubstation.dmm"

	traits = null
	space_ruin_levels = 3

	minetype = "none"

	allow_custom_shuttles = TRUE
	shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box",
	)

	job_changes = list()

	overmap_object_type = /datum/overmap_object/shuttle/station
