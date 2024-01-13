/datum/overmap_map_zone_generator/barren
	name = "Barren Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/barren
	map_zone_generator = /datum/map_zone_generator/barren

/datum/map_zone_generator/barren
	mapzone_name = "Barren Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/barren
	terrain_generator = /datum/terrain_generator/map_generator/barren
	ruin_generator = /datum/ruin_generator/basic/barren
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller
	day_night_controller = /datum/day_night_controller
	atmosphere = /datum/atmosphere/barren
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_BEIGE_GRAYISH, COLOR_BEIGE, COLOR_GRAY, COLOR_BROWN)
	plant_color = null
	plant_color_as_grass = FALSE
	grass_color = null
	water_color = null

/datum/base_map_generator/empty_levels/barren
	level_amount = 1
	turf_type = null
	area_type = /area/planet/barren
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/barren))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/barren
	map_generator = /datum/map_generator/planet_gen/barren

/datum/ruin_generator/basic/barren
	flags = RUIN_REMOTE|RUIN_WRECKAGE
	budget = 20
	allowed_areas = list(/area/planet/barren)

/datum/overmap_map_zone_generator/barren/quad
	name = "Barren Planetoid"
	overmap_type = /datum/overmap_object/shuttle/planet/barren/quad
	map_zone_generator = /datum/map_zone_generator/barren/quad

/datum/map_zone_generator/barren/quad
	mapzone_name = "Barren Planetoid"
	base_map_generator = /datum/base_map_generator/empty_levels/barren/quad
	ruin_generator = /datum/ruin_generator/basic/barren/quad

/datum/base_map_generator/empty_levels/barren/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/barren/quad
	budget = 15

/datum/overmap_object/shuttle/planet/barren/quad
	name = "Barren Planetoid"
	planet_color = COLOR_BEIGE_GRAYISH
	visual_type = /obj/effect/abstract/overmap/shuttle/planet/small

/datum/overmap_object/shuttle/planet/barren
	name = "Barren Planet"
	planet_color = COLOR_BEIGE_GRAYISH

/area/planet/barren
	name = "Barren Planet Surface"
	main_ambience = AMBIENCE_WINDY

/datum/map_generator/planet_gen/barren
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/barren,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGH_HUMIDITY = /datum/biome/barren
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/barren,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGH_HUMIDITY = /datum/biome/barren
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/barren,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGH_HUMIDITY = /datum/biome/barren
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/barren,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/barren,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/mountain,
		BIOME_HIGH_HUMIDITY = /datum/biome/mountain
		)
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/barren
	turf_type = /turf/open/floor/planetary/barren

/turf/open/floor/planetary/barren
	gender = PLURAL
	name = "barren rock"
	baseturfs = /turf/open/floor/planetary/barren
	icon = 'icons/planet/barren/barren_floor.dmi'
	icon_state = "barren"
	base_icon_state = "barren"
	footstep = FOOTSTEP_GENERIC_HEAVY
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/datum/atmosphere/barren
	base_gases = list(/datum/gas/nitrogen=5)
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5
	)
	restricted_gases = list(
		/datum/gas/plasma=0.1,
		/datum/gas/bz=1.2
	)
	restricted_chance = 30

	minimum_pressure = HAZARD_LOW_PRESSURE - 10
	maximum_pressure = HAZARD_LOW_PRESSURE + 5

	minimum_temp = 180
	maximum_temp = 180
