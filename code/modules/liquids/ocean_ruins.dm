/datum/map_template/ruin/ocean
	prefix = "_maps/RandomRuins/OceanRuins/"

/datum/map_template/ruin/ocean/fissure
	name = "Thermal Fissure"
	id = "ocean-fissure"
	description = "A tear in the ocean."
	suffix = "ocean_fissure.dmm"
	cost = 5

/datum/map_template/ruin/ocean/fissure/diag
	name = "Horizontal Thermal Fissure"
	id = "ocean-fissure-diag"
	description = "A horizontal tear in the ocean."
	suffix = "ocean_fissure_diag.dmm"

/datum/map_template/ruin/ocean/listening_outpost
	name = "Ocean Listening Outpost"
	id = "ocean-listening"
	description = "A listening outpost in the ocean."
	suffix = "ocean_listening_outpost.dmm"
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/ruin/ocean/mining_site
	name = "Ocean Mining Site"
	id = "ocean-miningsite"
	description = "Ocean mining site."
	suffix = "ocean_mining_above.dmm"
	cost = 10
	allow_duplicates = FALSE
	always_spawn_with = list(/datum/map_template/ruin/ocean/mining_site_below = PLACE_BELOW)

/datum/map_template/ruin/ocean/mining_site_below
	name = "Ocean Mining Site Underground"
	id = "ocean-miningsite-ug"
	description = "Ocean mining site down."
	suffix = "ocean_mining_below.dmm"
	unpickable = TRUE

//Some copypastas ahead, but it's how our ruins spawning system works
/datum/map_template/ruin/ocean_station
	prefix = "_maps/RandomRuins/OceanRuins/"

/datum/map_template/ruin/ocean_station/fissure
	name = "Thermal Fissure"
	id = "ocean-fissure"
	description = "A tear in the ocean."
	suffix = "ocean_fissure.dmm"
	cost = 5

/datum/map_template/ruin/ocean_station/fissure/diag
	name = "Horizontal Thermal Fissure"
	id = "ocean-fissure-diag"
	description = "A horizontal tear in the ocean."
	suffix = "ocean_fissure_diag.dmm"

/datum/map_template/ruin/trench
	prefix = "_maps/RandomRuins/OceanRuins/"

/datum/map_template/ruin/trench/fissure
	name = "Thermal Fissure"
	id = "ocean-fissure"
	description = "A tear in the ocean."
	suffix = "ocean_fissure.dmm"
	cost = 5

/datum/map_template/ruin/trench/fissure/diag
	name = "Horizontal Thermal Fissure"
	id = "ocean-fissure-diag"
	description = "A horizontal tear in the ocean."
	suffix = "ocean_fissure_diag.dmm"
