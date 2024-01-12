#define LANDING_PAD_NE 0
#define LANDING_PAD_NW 1
#define LANDING_PAD_SE 2
#define LANDING_PAD_SW 3

/datum/map_template/ruin/landing_pad
	description = "Landing pad."
	prefix = "_maps/landing_pad/"
	unpickable = TRUE
	var/spawn_position = LANDING_PAD_NE

/datum/map_template/ruin/landing_pad/ne_large
	name = "NE Large Landing Pad"
	id = "ne-large"
	suffix = "ne_large.dmm"
	spawn_position = LANDING_PAD_NE

/datum/map_template/ruin/landing_pad/sw_large
	name = "SW Large Landing Pad"
	id = "sw-large"
	suffix = "sw_large.dmm"
	spawn_position = LANDING_PAD_SW

/datum/map_template/ruin/landing_pad/nw_medium
	name = "NW Medium Landing Pad"
	id = "nw-medium"
	suffix = "nw_medium.dmm"
	spawn_position = LANDING_PAD_NW

/datum/map_template/ruin/landing_pad/se_medium
	name = "SE Medium Landing Pad"
	id = "se-medium"
	suffix = "se_medium.dmm"
	spawn_position = LANDING_PAD_SE
