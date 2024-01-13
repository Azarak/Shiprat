/datum/ruin_generator

/datum/ruin_generator/proc/generate(datum/map_zone/mapzone)
	return

/datum/ruin_generator/basic
	var/flags = NONE
	var/budget = 20
	var/list/allowed_areas = list()

/datum/ruin_generator/basic/generate(datum/map_zone/mapzone)
	var/list/candidates = SSmapping.ruins_templates
	var/list/eligible_ruins = list()
	for(var/ruin_name in candidates)
		var/datum/map_template/ruin/ruin = candidates[ruin_name]
		if(!(flags & ruin.requirements))
			continue
		eligible_ruins[ruin_name] = ruin
	seedRuins(mapzone.virtual_levels, budget, allowed_areas, eligible_ruins)
