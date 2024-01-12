/datum/overmap_map_zone_generator/lush
	name = "Lush Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/lush
	map_zone_generator = /datum/map_zone_generator/lush

/datum/map_zone_generator/lush
	mapzone_name = "Lush Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/lush
	terrain_generator = /datum/terrain_generator/map_generator/lush
	ruin_generator = /datum/ruin_generator/basic/lush
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/lush
	day_night_controller = /datum/day_night_controller
	atmosphere = /datum/atmosphere/lush
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_ASTEROID_ROCK, COLOR_GRAY, COLOR_BROWN)
	plant_color = list("#215a00","#195a47","#5a7467","#9eab88","#6e7248")
	grass_color = null
	water_color = null
	plant_color_as_grass = TRUE

/datum/base_map_generator/empty_levels/lush
	level_amount = 1
	turf_type = null
	area_type = /area/planet/lush
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/lush
	map_generator = /datum/map_generator/planet_gen/lush

/datum/ruin_generator/basic/lush
	flags = RUIN_WATER|RUIN_WRECKAGE|RUIN_HABITABLE
	budget = 40
	allowed_areas = list(/area/planet/lush)

/datum/weather_controller/lush
	possible_weathers = list(
		/datum/weather/rain = 30,
		/datum/weather/rain/heavy = 30,
		/datum/weather/rain/heavy/storm = 30,
	)

/datum/overmap_object/shuttle/planet/lush
	name = "Lush Planet"
	planet_color = COLOR_GREEN

/area/planet/lush
	name = "Lush Planet Surface"
	main_ambience = AMBIENCE_WINDY

/datum/map_generator/planet_gen/lush
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/grass,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/heavy_mud,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/grass,
		BIOME_HIGH_HUMIDITY = /datum/biome/grass,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/grass,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/grass,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/coast,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/grass,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/grass,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/coast,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/wasteland,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/grass,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/coast,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/grass
	turf_type = /turf/open/floor/planetary/grass
	flora_types = list(
		/obj/structure/flora/tree/jungle,
		/obj/structure/flora/planetary/palebush,
		/obj/structure/flora/rock/pile,
		/obj/structure/flora/ausbushes/ywflowers,
		/obj/structure/flora/ausbushes/brflowers,
		/obj/structure/flora/ausbushes/brflowers,
		/obj/structure/flora/ausbushes/lavendergrass,
		/obj/structure/flora/ausbushes/goldenbush,
		/obj/structure/flora/planetary/leafybush,
		/obj/structure/flora/planetary/grassybush,
		/obj/structure/flora/planetary/fernybush,
		/obj/structure/flora/planetary/sunnybush,
		/obj/structure/flora/planetary_grass/sparsegrass,
		/obj/structure/flora/planetary_grass/fullgrass,
	)
	flora_density = 10
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/tindalos = 1,
		/mob/living/simple_animal/yithian = 1,
		/mob/living/simple_animal/hostile/planet/jelly = 1,
	)

/datum/biome/coast
	turf_type = /turf/open/floor/planetary/sand

/datum/biome/heavy_mud
	turf_type = /turf/open/floor/planetary/mud

/datum/biome/wasteland
	turf_type = /turf/open/floor/planetary/wasteland

/datum/atmosphere/lush
	base_gases = list(
		/datum/gas/nitrogen=80,
		/datum/gas/oxygen=20,
	)
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE - 10
	maximum_pressure = ONE_ATMOSPHERE + 20

	minimum_temp = T20C - 10
	maximum_temp = T20C + 20
