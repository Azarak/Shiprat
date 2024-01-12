/datum/overmap_map_zone_generator/desert
	name = "Desert Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/desert
	map_zone_generator = /datum/map_zone_generator/desert

/datum/map_zone_generator/desert
	mapzone_name = "Desert Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/desert
	terrain_generator = /datum/terrain_generator/map_generator/desert
	ruin_generator = /datum/ruin_generator/basic/desert
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/desert
	day_night_controller = /datum/day_night_controller
	atmosphere = /datum/atmosphere/desert
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY, COLOR_BROWN)
	plant_color = list("#7b4a12","#e49135","#ba6222")
	grass_color = list("#b8701f")
	water_color = null
	plant_color_as_grass = FALSE

/datum/base_map_generator/empty_levels/desert
	level_amount = 1
	turf_type = null
	area_type = /area/planet/desert
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/desert
	map_generator = /datum/map_generator/planet_gen/desert

/datum/ruin_generator/basic/desert
	flags = RUIN_WATER|RUIN_WRECKAGE|RUIN_REMOTE
	budget = 40
	allowed_areas = list(/area/planet/desert)

/datum/overmap_map_zone_generator/desert/quad
	name = "Desert Planetoid"
	overmap_type = /datum/overmap_object/shuttle/planet/desert/quad
	map_zone_generator = /datum/map_zone_generator/desert/quad

/datum/map_zone_generator/desert/quad
	mapzone_name = "Desert Planetoid"
	base_map_generator = /datum/base_map_generator/empty_levels/desert/quad
	ruin_generator = /datum/ruin_generator/basic/desert/quad

/datum/base_map_generator/empty_levels/desert/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/desert/quad
	budget = 15

/datum/overmap_object/shuttle/planet/desert/quad
	name = "Desert Planetoid"
	planet_color = COLOR_BEIGE_GRAYISH

/datum/weather_controller/desert
	possible_weathers = list(/datum/weather/sandstorm = 100)

/datum/overmap_object/shuttle/planet/desert
	name = "Desert Planet"
	planet_color = COLOR_BEIGE

/area/planet/desert
	name = "Desert Planet Surface"
	main_ambience = AMBIENCE_DESERT

/datum/map_generator/planet_gen/desert
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGH_HUMIDITY = /datum/biome/desert,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGH_HUMIDITY = /datum/biome/desert,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/dry_seafloor,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/desert,
		BIOME_HIGH_HUMIDITY = /datum/biome/desert,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/dry_seafloor,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/dry_seafloor,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/dry_seafloor,
		BIOME_HIGH_HUMIDITY = /datum/biome/desert,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/desert
	turf_type = /turf/open/floor/planetary/sand/desert
	flora_types = list(
		/obj/structure/flora/planetary/palebush,
		/obj/structure/flora/rock/pile,
		/obj/structure/flora/rock,
		/obj/structure/flora/ash/cacti,
	)
	flora_density = 3
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/planet/antlion = 100,
		/mob/living/simple_animal/tindalos = 60,
		/mob/living/simple_animal/thinbug = 60,
		/mob/living/simple_animal/hostile/lizard = 20,
		/mob/living/simple_animal/hostile/planet/antlion/mega = 10,
	)

/datum/biome/dry_seafloor
	turf_type = /turf/open/floor/planetary/dry_seafloor

/datum/atmosphere/desert
	base_gases = list(
		/datum/gas/nitrogen=80,
		/datum/gas/oxygen=20,
	)
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE
	maximum_pressure = ONE_ATMOSPHERE  + 50

	minimum_temp = T20C + 20
	maximum_temp = T20C + 80

/turf/open/floor/planetary/sand/desert
	gender = PLURAL
	name = "desert sand"
	baseturfs = /turf/open/floor/planetary/sand/desert
