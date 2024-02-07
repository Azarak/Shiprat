/datum/custom_generator

/datum/custom_generator/proc/generate(datum/map_zone/mapzone)
	return

/datum/custom_generator/landing_pads/generate(datum/map_zone/mapzone)
	var/datum/virtual_level/vlevel = mapzone.virtual_levels[1]
	for(var/path in SSmapping.landing_pad_templates)
		var/start_x = 0
		var/start_y = 0
		var/datum/map_template/ruin/landing_pad/pad = SSmapping.landing_pad_templates[path]
		var/half_height = CEILING((pad.height / 2), 1)
		var/half_width = CEILING((pad.width / 2), 1)
		switch(pad.spawn_position)
			if(LANDING_PAD_NE)
				start_x = vlevel.high_x - vlevel.reserved_margin - half_width
				start_y = vlevel.high_y - vlevel.reserved_margin - half_height
			if(LANDING_PAD_NW)
				start_x = vlevel.low_x + vlevel.reserved_margin + half_width
				start_y = vlevel.high_y - vlevel.reserved_margin - half_height
			if(LANDING_PAD_SE)
				start_x = vlevel.high_x - vlevel.reserved_margin - half_width
				start_y = vlevel.low_y + vlevel.reserved_margin + half_height
			if(LANDING_PAD_SW)
				start_x = vlevel.low_x + vlevel.reserved_margin + half_width
				start_y = vlevel.low_y + vlevel.reserved_margin + half_height
		pad.try_to_place(vlevel, list(), locate(start_x, start_y, vlevel.z_value), TRUE)

/datum/custom_generator/spawn_ruin
	var/map_template = null

/datum/custom_generator/spawn_ruin/generate(datum/map_zone/mapzone)
	var/datum/virtual_level/vlevel = mapzone.virtual_levels[1]
	var/turf/middle = vlevel.get_center()
	var/datum/map_template/ruin/ruin_template = SSmapping.ruins_templates_by_type[map_template]
	if(ruin_template == null)
		ruin_template = new map_template()
	ruin_template.load(middle, TRUE, TRUE)

/datum/custom_generator/spawn_ruin/bunker
	map_template = /datum/map_template/ruin/special/bunker

/datum/custom_generator/spawn_ruin/charlie
	map_template = /datum/map_template/ruin/special/charlie
