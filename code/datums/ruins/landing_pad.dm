#define LANDING_PAD_NE 0
#define LANDING_PAD_NW 1
#define LANDING_PAD_SE 2
#define LANDING_PAD_SW 3

/datum/map_template/ruin/landing_pad
	description = "Landing pad."
	prefix = "_maps/landing_pad/"
	var/spawn_position = LANDING_PAD_NE

/datum/map_template/ruin/landing_pad/ne_huge
	name = "NE Huge Landing Pad"
	id = "ne-huge"
	suffix = "ne_huge.dmm"
	spawn_position = LANDING_PAD_NE

/datum/map_template/ruin/landing_pad/sw_huge
	name = "SW Huge Landing Pad"
	id = "sw-huge"
	suffix = "sw_huge.dmm"
	spawn_position = LANDING_PAD_SE

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
