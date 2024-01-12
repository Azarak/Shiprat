/datum/overmap_map_zone_generator/jungle
	name = "Jungle Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/jungle
	map_zone_generator = /datum/map_zone_generator/jungle

/datum/map_zone_generator/jungle
	mapzone_name = "Jungle Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/jungle
	terrain_generator = /datum/terrain_generator/map_generator/jungle
	ruin_generator = /datum/ruin_generator/basic/jungle
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/lush
	day_night_controller = /datum/day_night_controller
	atmosphere = /datum/atmosphere/jungle
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_BEIGE_GRAYISH, COLOR_BEIGE, COLOR_ASTEROID_ROCK)
	plant_color = list(COLOR_PALE_BTL_GREEN)
	grass_color = null
	water_color = null
	plant_color_as_grass = TRUE

/datum/base_map_generator/empty_levels/jungle
	level_amount = 1
	turf_type = null
	area_type = /area/planet/jungle
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/jungle
	map_generator = /datum/map_generator/planet_gen/jungle

/datum/ruin_generator/basic/jungle
	flags = RUIN_WATER|RUIN_WRECKAGE|RUIN_HABITABLE
	budget = 40
	allowed_areas = list(/area/planet/jungle)

/datum/overmap_object/shuttle/planet/jungle
	name = "Jungle Planet"
	planet_color = COLOR_PALE_BTL_GREEN

/area/planet/jungle
	name = "Jungle Planet Surface"
	main_ambience = AMBIENCE_JUNGLE

/datum/map_generator/planet_gen/jungle
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/mudlands,
		BIOME_HIGH_HUMIDITY = /datum/biome/water,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/mudlands,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/plains,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle/deep,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/wasteland,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/plains,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/jungle,
		BIOME_HIGH_HUMIDITY = /datum/biome/jungle/deep,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/mudlands
	turf_type = /turf/open/floor/planetary/dirt/jungle/dark
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/rock/jungle,
		/obj/structure/flora/rock/pile/largejungle,
	)
	flora_density = 3

/datum/biome/plains
	turf_type = /turf/open/floor/planetary/grass
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/tree/jungle,
		/obj/structure/flora/rock/jungle,
		/obj/structure/flora/junglebush,
		/obj/structure/flora/junglebush/b,
		/obj/structure/flora/junglebush/c,
		/obj/structure/flora/junglebush/large,
		/obj/structure/flora/rock/pile/largejungle,
	)
	flora_density = 15

/datum/biome/jungle
	turf_type = /turf/open/floor/planetary/grass
	flora_types = list(
		/obj/structure/flora/grass/jungle,
		/obj/structure/flora/grass/jungle/b,
		/obj/structure/flora/tree/jungle,
		/obj/structure/flora/rock/jungle,
		/obj/structure/flora/junglebush,
		/obj/structure/flora/junglebush/b,
		/obj/structure/flora/junglebush/c,
		/obj/structure/flora/junglebush/large,
		/obj/structure/flora/rock/pile/largejungle,
	)
	flora_density = 40
	fauna_density = 0.3
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 30,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/jungle/deep
	flora_density = 65
	fauna_density = 0.3
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/jungle/leaper = 30,
		/mob/living/simple_animal/hostile/jungle/mega_arachnid = 100,
		/mob/living/simple_animal/hostile/jungle/mook = 100,
		/mob/living/simple_animal/hostile/jungle/seedling = 100,
	)

/datum/biome/wasteland
	turf_type = /turf/open/floor/planetary/wasteland

/datum/atmosphere/jungle
	base_gases = list(
		/datum/gas/nitrogen=80,
		/datum/gas/oxygen=20,
	)
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5,
		/datum/gas/carbon_dioxide=2,
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE
	maximum_pressure = ONE_ATMOSPHERE + 20

	minimum_temp = T20C + 20
	maximum_temp = T20C + 40
