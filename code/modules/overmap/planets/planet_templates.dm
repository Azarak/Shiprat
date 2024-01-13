/datum/overmap_map_zone_generator
	var/name = "Planet Template"
	/// The type of the overmap object that will be created
	var/overmap_type = /datum/overmap_object/shuttle/planet
	/// Type of the map zone to be used
	var/map_zone_generator

/datum/overmap_map_zone_generator/proc/generate(datum/overmap_sun_system/system, coordinate_x, coordinate_y)
	var/datum/overmap_object/linked_overmap_object = new overmap_type(system, coordinate_x, coordinate_y)
	var/datum/map_zone_generator/generator = new map_zone_generator()
	var/datum/map_zone/map_zone = generator.generate(linked_overmap_object)
	return map_zone

/datum/overmap_map_zone_generator/lavaland
	name = "Lavaland"
	overmap_type = /datum/overmap_object/shuttle/planet/lavaland
	map_zone_generator = /datum/map_zone_generator/lavaland

/datum/map_zone_generator/lavaland
	mapzone_name = "Lavaland"
	base_map_generator = /datum/base_map_generator/load_file/lavaland
	terrain_generator = null
	ruin_generator = /datum/ruin_generator/basic/lavaland
	pre_custom_generators = null
	post_custom_generators = null
	weather_controller = /datum/weather_controller/lavaland
	day_night_controller = null  //Ash blocks off the sky
	atmosphere = /datum/atmosphere/lavaland
	ore_node_seeder = /datum/ore_node_seeder
	rock_color = null
	plant_color = list("#a23c05","#662929","#ba6222","#7a5b3a")
	plant_color_as_grass = TRUE
	grass_color = null
	water_color = null

/datum/base_map_generator/load_file/lavaland
	map_path = "map_files/Mining"
	map_files = list("Lavaland.dmm")
	traits = list(
		ZTRAITS_LAVALAND
	)
	self_looping = FALSE
	map_margin = 0
	size_x = 255
	size_y = 255
	allocation_type = ALLOCATION_FULL

/datum/ruin_generator/basic/lavaland
	flags = RUIN_LAVALAND
	budget = 20
	allowed_areas = list(/area/lavaland/surface/outdoors/unexplored)
