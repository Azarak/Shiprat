/datum/overmap_map_zone_generator/asteroid
	name = "Asteroid"
	overmap_type = /datum/overmap_object/shuttle/planet/asteroid
	map_zone_generator = /datum/map_zone_generator/asteroid

/datum/map_zone_generator/asteroid
	mapzone_name = "Asteroid"
	base_map_generator = /datum/base_map_generator/empty_levels/asteroid
	terrain_generator = /datum/terrain_generator/asteroid
	ruin_generator = /datum/ruin_generator/basic/asteroid
	pre_custom_generators = list(/datum/custom_generator/landing_pads)
	post_custom_generators = null
	weather_controller = /datum/weather_controller
	day_night_controller = null
	atmosphere = null
	ore_node_seeder = null
	rock_color = list(COLOR_ASTEROID_ROCK)
	plant_color = null
	plant_color_as_grass = FALSE
	grass_color = null
	water_color = null

/datum/base_map_generator/empty_levels/asteroid
	level_amount = 1
	turf_type = null
	area_type = /area/asteroid_planet
	traits = list(list(ZTRAIT_MINING = TRUE, ZTRAIT_BASETURF = /turf/open/floor/plating/asteroid/airless))
	self_looping = FALSE
	map_margin = MAP_EDGE_PAD
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/ruin_generator/basic/asteroid
	flags = RUIN_SPACE
	budget = 40
	allowed_areas = list(/area/asteroid_planet)

/datum/overmap_object/shuttle/planet/asteroid
	name = "Asteroid"
	planet_color = COLOR_GRAY

#define ASTEROID_GEN_DISTANCE_COEFF_FALLOFF 0.8
#define ASTEROID_RANDOM_SQUARE_DRIFT 0

/datum/terrain_generator/asteroid
	var/falloff = ASTEROID_GEN_DISTANCE_COEFF_FALLOFF

/datum/terrain_generator/asteroid/proc/height_to_biome(height)
	switch(height)
		if(0 to 0.25)
			return /datum/biome/asteroid_rock_rich
		if(0.25 to 0.5)
			return /datum/biome/asteroid_rock
		if(0.5 to 0.75)
			return /datum/biome/asteroid_sand
		else
			return /datum/biome/asteroid_space

/datum/terrain_generator/asteroid/generate(datum/map_zone/mapzone)
	var/perlin_zoom = 20
	var/height_seed = rand(0,50000)
	for(var/datum/virtual_level/vlevel as anything in mapzone.virtual_levels)
		for(var/x in vlevel.low_x + vlevel.reserved_margin to vlevel.high_x - vlevel.reserved_margin)
			for(var/y in vlevel.low_y + vlevel.reserved_margin to vlevel.high_y - vlevel.reserved_margin)
				var/turf/turfatlocation = locate(x,y,vlevel.z_value)
				var/drift_x = (x + rand(-ASTEROID_RANDOM_SQUARE_DRIFT, ASTEROID_RANDOM_SQUARE_DRIFT)) / perlin_zoom
				var/drift_y = (y + rand(-ASTEROID_RANDOM_SQUARE_DRIFT, ASTEROID_RANDOM_SQUARE_DRIFT)) / perlin_zoom

				var/middle_x = round((vlevel.low_x + vlevel.high_x) / 2)
				var/middle_y = round((vlevel.low_y + vlevel.high_y) / 2)

				var/distance_coeff_x = abs(middle_x - x) / middle_x
				var/distance_coeff_y = abs(middle_y - y) / middle_y

				var/final_distance_coeff = (distance_coeff_x > distance_coeff_y) ? distance_coeff_x : distance_coeff_y

				var/height = text2num(rustg_noise_get_at_coordinates("[height_seed]", "[drift_x]", "[drift_y]"))
				if(final_distance_coeff > falloff)
					height += ((final_distance_coeff - falloff) / (1 - falloff))
				var/biome = height_to_biome(height)
				var/datum/biome/selected_biome = SSmapping.biomes[biome] //Get the instance of this biome from SSmapping
				selected_biome.generate_turf(turfatlocation)

/datum/biome/asteroid_space
	turf_type = /turf/open/space

/datum/biome/asteroid_sand
	turf_type = /turf/open/floor/plating/asteroid/airless

/datum/biome/asteroid_rock
	turf_type = /turf/closed/mineral/random

/datum/biome/asteroid_rock_rich
	turf_type = /turf/closed/mineral/random/high_chance

/datum/overmap_map_zone_generator/asteroid/quad
	name = "Tiny Asteroid"
	overmap_type = /datum/overmap_object/shuttle/planet/asteroid/quad
	map_zone_generator = /datum/map_zone_generator/asteroid/quad

/datum/map_zone_generator/asteroid/quad
	mapzone_name = "Tiny Asteroid"
	base_map_generator = /datum/base_map_generator/empty_levels/asteroid/quad
	ruin_generator = /datum/ruin_generator/basic/asteroid/quad

/datum/base_map_generator/empty_levels/asteroid/quad
	size_x = 127
	size_y = 127
	allocation_type = ALLOCATION_QUADRANT

/datum/ruin_generator/basic/asteroid/quad
	budget = 15

/datum/overmap_object/shuttle/planet/asteroid/quad
	name = "Tiny Asteroid"
	planet_color = COLOR_GRAY

/area/asteroid_planet
	name = "Asteroid"
	icon_state = "asteroid"
	has_gravity = FALSE
	flags_1 = NONE
	always_unpowered = FALSE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
	main_ambience = AMBIENCE_AWAY
	outdoors = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
