/datum/overmap_map_zone_generator/volcanic
	name = "Snow Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/volcanic
	map_zone_generator = /datum/map_zone_generator/volcanic

/datum/map_zone_generator/volcanic
	mapzone_name = "Snow Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/volcanic
	terrain_generator = /datum/terrain_generator/map_generator/volcanic
	ruin_generator = /datum/ruin_generator/basic/volcanic
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/lavaland
	day_night_controller = null // Ash blocks the sky
	atmosphere = /datum/atmosphere/volcanic
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_DARK_GRAY)
	plant_color = list("#a23c05","#662929","#ba6222","#7a5b3a")
	grass_color = null
	water_color = null
	plant_color_as_grass = TRUE

/datum/base_map_generator/empty_levels/volcanic
	level_amount = 1
	turf_type = null
	area_type = /area/planet/snow
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/volcanic
	map_generator = /datum/map_generator/planet_gen/volcanic

/datum/ruin_generator/basic/volcanic
	flags = RUIN_WRECKAGE|RUIN_VOLCANIC|RUIN_REMOTE
	budget = 40
	allowed_areas = list(/area/planet/volcanic)

/datum/overmap_map_zone_generator/volcanic/quad
	name = "Volcanic Planetoid"
	overmap_type = /datum/overmap_object/shuttle/planet/volcanic/quad
	map_zone_generator = /datum/map_zone_generator/volcanic/quad

/datum/map_zone_generator/volcanic/quad
	mapzone_name = "Volcanic Planetoid"
	base_map_generator = /datum/base_map_generator/empty_levels/volcanic/quad
	ruin_generator = /datum/ruin_generator/basic/volcanic/quad

/datum/base_map_generator/empty_levels/volcanic/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/volcanic/quad
	budget = 15

/datum/overmap_object/shuttle/planet/volcanic/quad
	name = "Volcanic Planetoid"
	planet_color = COLOR_BEIGE_GRAYISH

/datum/overmap_object/shuttle/planet/volcanic
	name = "Volcanic Planet"
	planet_color = COLOR_RED

/area/planet/volcanic
	name = "Volcanic Planet Surface"
	main_ambience = AMBIENCE_MAGMA

/datum/map_generator/planet_gen/volcanic
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/mountain,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/mountain,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGH_HUMIDITY = /datum/biome/basalt,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/basalt,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGH_HUMIDITY = /datum/biome/basalt,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/basalt,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGH_HUMIDITY = /datum/biome/lava,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/basalt,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/basalt,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/lava,
		BIOME_HIGH_HUMIDITY = /datum/biome/lava,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/basalt
	turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	flora_types = list(
		/obj/structure/flora/rock,
		/obj/structure/flora/rock/pile,
		/obj/structure/flora/ash/tall_shroom,
		/obj/structure/flora/ash/leaf_shroom,
		/obj/structure/flora/ash/cap_shroom,
		/obj/structure/flora/ash/stem_shroom,
		/obj/structure/flora/ash/cacti,
	)
	flora_density = 7
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/megafauna/dragon = 4,
		/mob/living/simple_animal/hostile/planet/charbaby = 100,
		/mob/living/simple_animal/hostile/planet/shantak/lava = 100,
		/mob/living/simple_animal/hostile/asteroid/goliath/beast = 100,
		/mob/living/simple_animal/thinbug = 50,
	)

/datum/biome/lava
	turf_type = /turf/open/lava/smooth/lava_land_surface

/datum/atmosphere/volcanic
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

	minimum_pressure = ONE_ATMOSPHERE + 30
	maximum_pressure = ONE_ATMOSPHERE + 80

	minimum_temp = T20C + 100
	maximum_temp = T20C + 200
