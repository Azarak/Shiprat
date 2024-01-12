/datum/overmap_map_zone_generator/shrouded
	name = "Shrouded Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/shrouded
	map_zone_generator = /datum/map_zone_generator/shrouded

/datum/map_zone_generator/shrouded
	mapzone_name = "Shrouded Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/shrouded
	terrain_generator = /datum/terrain_generator/map_generator/shrouded
	ruin_generator = /datum/ruin_generator/basic/shrouded
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/shrouded
	day_night_controller = /datum/day_night_controller/shrouded
	atmosphere = /datum/atmosphere/shrouded
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_INDIGO, COLOR_DARK_BLUE_GRAY, COLOR_NAVY_BLUE)
	plant_color = list("#3c5434", "#2f6655", "#0e703f", "#495139", "#394c66", "#1a3b77", "#3e3166", "#52457c", "#402d56", "#580d6d")
	grass_color = null
	water_color = list("#3e3960")
	plant_color_as_grass = TRUE

/datum/base_map_generator/empty_levels/shrouded
	level_amount = 1
	turf_type = null
	area_type = /area/planet/shrouded
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/shrouded
	map_generator = /datum/map_generator/planet_gen/shrouded

/datum/ruin_generator/basic/shrouded
	flags = RUIN_WATER|RUIN_WRECKAGE|RUIN_REMOTE
	budget = 40
	allowed_areas = list(/area/planet/shrouded)

/datum/overmap_map_zone_generator/shrouded/quad
	name = "Shrouded Planetoid"
	overmap_type = /datum/overmap_object/shuttle/planet/shrouded/quad
	map_zone_generator = /datum/map_zone_generator/shrouded/quad

/datum/map_zone_generator/shrouded/quad
	mapzone_name = "Shrouded Planetoid"
	base_map_generator = /datum/base_map_generator/empty_levels/shrouded/quad
	ruin_generator = /datum/ruin_generator/basic/shrouded/quad

/datum/base_map_generator/empty_levels/shrouded/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/shrouded/quad
	budget = 15

/datum/overmap_object/shuttle/planet/shrouded/quad
	name = "Shrouded Planetoid"
	planet_color = COLOR_BEIGE_GRAYISH

/datum/day_night_controller/shrouded
	midnight_color = COLOR_BLACK
	midnight_light = 0

	morning_color = "#c4faff"
	morning_light = 0.4

	noon_color = "#bffff2"
	noon_light = 0.7

	midday_color = "#bffff2"
	midday_light = 0.7

	evening_color = "#c43f3f"
	evening_light = 0.4

	night_color = "#0000a6"
	night_light = 0.1

/datum/weather_controller/shrouded
	possible_weathers = list(/datum/weather/shroud_storm = 100)

/datum/overmap_object/shuttle/planet/shrouded
	name = "Shrouded Planet"
	planet_color = COLOR_BLUE

/area/planet/shrouded
	name = "Shrouded Planet Surface"
	main_ambience = AMBIENCE_SHROUDED

/datum/map_generator/planet_gen/shrouded
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/mountain,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGH_HUMIDITY = /datum/biome/shrouded_sand,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGH_HUMIDITY = /datum/biome/shrouded_tar,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGH_HUMIDITY = /datum/biome/shrouded_tar,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/shrouded_sand,
		BIOME_HIGH_HUMIDITY = /datum/biome/shrouded_tar,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/shrouded_sand
	turf_type = /turf/open/floor/planetary/shrouded_sand
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/planet/royalcrab = 100,
		/mob/living/simple_animal/hostile/planet/jelly/alt = 100,
		/mob/living/simple_animal/hostile/planet/shantak/alt = 100,
	)

/datum/biome/shrouded_tar
	turf_type = /turf/open/floor/planetary/water/tar

/turf/open/floor/planetary/shrouded_sand
	gender = PLURAL
	name = "packed sand"
	desc = "Sand that has been packed into solid earth."
	baseturfs = /turf/open/floor/planetary/shrouded_sand
	icon = 'icons/planet/shrouded/shrouded_floor.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND

/turf/open/floor/planetary/shrouded_sand/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(20))
		icon_state = "[base_icon_state][rand(1,8)]"

/datum/atmosphere/shrouded
	base_gases = list(
		/datum/gas/nitrogen=80,
		/datum/gas/oxygen=20,
	)
	normal_gases = list(
		/datum/gas/bz=2,
		/datum/gas/carbon_dioxide=2,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE - 10
	maximum_pressure = ONE_ATMOSPHERE + 20

	minimum_temp = T20C - 30
	maximum_temp = T20C - 10
