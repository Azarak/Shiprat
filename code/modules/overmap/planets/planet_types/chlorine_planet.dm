/datum/overmap_map_zone_generator/chlorine
	name = "Chlorine Planet"
	overmap_type = /datum/overmap_object/shuttle/planet/chlorine
	map_zone_generator = /datum/map_zone_generator/chlorine

/datum/map_zone_generator/chlorine
	mapzone_name = "Chlorine Planet"
	base_map_generator = /datum/base_map_generator/empty_levels/chlorine
	terrain_generator = /datum/terrain_generator/map_generator/chlorine
	ruin_generator = /datum/ruin_generator/basic/chlorine
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller/chlorine
	day_night_controller = /datum/day_night_controller/chlorine
	atmosphere = /datum/atmosphere/chlorine
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = list(COLOR_GRAY, COLOR_PALE_GREEN_GRAY, COLOR_PALE_BTL_GREEN)
	plant_color = null
	plant_color_as_grass = FALSE
	grass_color = null
	water_color = null

/datum/base_map_generator/empty_levels/chlorine
	level_amount = 1
	turf_type = null
	area_type = /area/planet/chlorine
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/planetary/rock))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/terrain_generator/map_generator/chlorine
	map_generator = /datum/map_generator/planet_gen/chlorine

/datum/ruin_generator/basic/chlorine
	flags = RUIN_WATER|RUIN_WRECKAGE|RUIN_REMOTE
	budget = 20
	allowed_areas = list(/area/planet/chlorine)

/datum/overmap_map_zone_generator/chlorine/quad
	name = "Chlorine Planetoid"
	overmap_type = /datum/overmap_object/shuttle/planet/chlorine/quad
	map_zone_generator = /datum/map_zone_generator/chlorine/quad

/datum/map_zone_generator/chlorine/quad
	mapzone_name = "Chlorine Planetoid"
	base_map_generator = /datum/base_map_generator/empty_levels/chlorine/quad
	ruin_generator = /datum/ruin_generator/basic/chlorine/quad

/datum/base_map_generator/empty_levels/chlorine/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/chlorine/quad
	budget = 10

/datum/overmap_object/shuttle/planet/chlorine/quad
	name = "Chlorine Planetoid"
	planet_color = COLOR_BEIGE_GRAYISH

/datum/weather_controller/chlorine
	possible_weathers = list(/datum/weather/acid_rain = 100)

/datum/day_night_controller/chlorine
	midnight_color = COLOR_BLACK
	midnight_light = 0

	morning_color = "#c4faff"
	morning_light = 0.4

	noon_color = "#fff79c"
	noon_light = 0.7

	midday_color = "#fff79c"
	midday_light = 0.7

	evening_color = "#c43f3f"
	evening_light = 0.4

	night_color = "#0000a6"
	night_light = 0.1

/datum/overmap_object/shuttle/planet/chlorine
	name = "Chlorine Planet"
	planet_color = COLOR_PALE_BTL_GREEN

/area/planet/chlorine
	name = "Chlorine Planet Surface"
	main_ambience = AMBIENCE_DESERT

/datum/map_generator/planet_gen/chlorine
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/chlorine_water,
		BIOME_HIGH_HUMIDITY = /datum/biome/chlorine_water,
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/chlorine_water,
		BIOME_HIGH_HUMIDITY = /datum/biome/chlorine_water,
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGH_HUMIDITY = /datum/biome/chlorine_water,
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/chlorine_desert,
		BIOME_HIGH_HUMIDITY = /datum/biome/chlorine_desert,
		),
	)
	high_height_biome = /datum/biome/mountain
	perlin_zoom = 65

/datum/biome/chlorine_desert
	turf_type = /turf/open/floor/planetary/chlorine_sand
	fauna_density = 0.5
	fauna_weight_types = list(
		/mob/living/simple_animal/hostile/planet/jelly = 100,
		/mob/living/simple_animal/tindalos = 50,
		/mob/living/simple_animal/thinbug = 50,
		/mob/living/simple_animal/yithian = 50,
		/mob/living/simple_animal/hostile/planet/samak/alt = 100,
		/mob/living/simple_animal/hostile/planet/jelly/mega = 5,
	)

/datum/biome/chlorine_water
	turf_type = /turf/open/floor/planetary/water/chlorine

/datum/atmosphere/chlorine
	base_gases = list(
		/datum/gas/nitrogen=80,
		/datum/gas/carbon_dioxide=20
	) //CO2 because chlorine gas isn't a thing now
	normal_gases = list(
		/datum/gas/oxygen=5,
		/datum/gas/nitrogen=5
	)
	restricted_chance = 0

	minimum_pressure = ONE_ATMOSPHERE - 30
	maximum_pressure = ONE_ATMOSPHERE

	minimum_temp = T20C - 100
	maximum_temp = T20C

/turf/open/floor/planetary/chlorine_sand
	gender = PLURAL
	name = "chlorinated sand"
	desc = "Sand that has been heavily contaminated by chlorine."
	baseturfs = /turf/open/floor/planetary/chlorine_sand
	icon = 'icons/planet/chlorine/chlorine_floor.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/planetary/chlorine_sand/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(20))
		icon_state = "[base_icon_state][rand(1,11)]"

/turf/open/floor/planetary/water/chlorine
	name = "chlorine marsh"
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."
	color = "#d2e0b7"
	baseturfs = /turf/open/floor/planetary/water/chlorine
