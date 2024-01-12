/datum/terrain_generator

/datum/terrain_generator/proc/generate(datum/map_zone/mapzone)
	return

/datum/terrain_generator/map_generator
	var/map_generator

/datum/terrain_generator/map_generator/generate(datum/map_zone/mapzone)
	for(var/datum/virtual_level/vlevel as anything in mapzone.virtual_levels)
		var/list/turfs = vlevel.get_unreserved_block()
		var/datum/map_generator/gen = new map_generator()
		gen.generate_terrain(turfs)
