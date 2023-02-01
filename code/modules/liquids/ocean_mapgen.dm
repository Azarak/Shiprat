/datum/map_generator/planet_gen/ocean_generator
	///2D list of all biomes based on heat and humidity combos.
	possible_biomes = list(
	BIOME_LOW_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/ocean_sand,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/ocean_sand_flora,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/ocean_sand_flora,
		BIOME_HIGH_HUMIDITY = /datum/biome/ocean_sand
		),
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/ocean_rocklight,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/ocean_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/ocean_redsand,
		BIOME_HIGH_HUMIDITY = /datum/biome/ocean_sand_flora
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/ocean_rockmed,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/ocean_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/ocean_redsand,
		BIOME_HIGH_HUMIDITY =/datum/biome/ocean_redsand
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/ocean_rockheavy,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/ocean_sand,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/ocean_redsand,
		BIOME_HIGH_HUMIDITY = /datum/biome/ocean_redsand
		)
	)
	high_height_biome = /datum/biome/ocean_wall
	perlin_zoom = 65

/datum/map_generator/cave_generator/trench
	name = "Trench Generator"
	open_turf_types =  list(/turf/open/floor/ocean/rock/heavy = 1)
	closed_turf_types =  list(/turf/closed/mineral/random/ocean = 1)

	feature_spawn_list = null

	mob_spawn_list = list(/mob/living/simple_animal/hostile/carp = 1)
	mob_spawn_chance = 1

	flora_spawn_chance = 4
	flora_spawn_list = list(/obj/structure/flora/rock = 1, /obj/structure/flora/rock/pile = 1)
