/area/ocean
	name = "Ocean"
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = NO_ALERTS
	outdoors = TRUE
	main_ambience = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE

/area/ocean/generated
	map_generator = /datum/map_generator/planet_gen/ocean_generator

/area/ocean/trench
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | NO_ALERTS
	name = "The Trench"

/area/ocean/trench/generated
	map_generator = /datum/map_generator/cave_generator/trench

/area/ruin/ocean
	has_gravity = TRUE

/area/ruin/ocean/listening_outpost
	area_flags = UNIQUE_AREA

/area/ruin/ocean/bunker
	area_flags = UNIQUE_AREA

/area/ruin/ocean/bioweapon_research
	area_flags = UNIQUE_AREA

/area/ruin/ocean/mining_site
	area_flags = UNIQUE_AREA
