/datum/map_zone_generator
	/// Name of the mapzone
	var/mapzone_name = "Unnamed"
	/// Generator to create the base levels, or load them from file
	var/base_map_generator = null
	/// Generator to generate terrain after map was loaded
	var/terrain_generator = null
	/// Generator to spawn in ruins
	var/ruin_generator = null
	/// Type of custom generator to be applied after terrain but before other generations have been applied
	var/list/pre_custom_generators = null
	/// Type of custom generator to be applied after all previous generations have been applied
	var/list/post_custom_generators = null
	/// The weather controller the station levels will have
	var/weather_controller = /datum/weather_controller
	/// Type of our day and night controller, can be left blank for none
	var/day_night_controller = null
	/// Type of the atmosphere that will be loaded for the map
	var/atmosphere = null
	// Type of the ore seeder for deep drills
	var/ore_node_seeder = null
	/// Possible rock colors of the loaded map
	var/list/rock_color = null
	/// Possible plant colors of the loaded map
	var/list/plant_color = null
	/// Possible grass colors of the loaded map
	var/list/grass_color = null
	/// Possible water colors of the loaded map
	var/list/water_color = null
	var/plant_color_as_grass = FALSE

/datum/map_zone_generator/proc/generate(datum/overmap_object/overmap_obj)
	var/datum/map_zone/mapzone = SSmapping.create_map_zone(mapzone_name, overmap_obj)

	if(atmosphere)
		var/datum/atmosphere/atmos = new atmosphere()
		mapzone.set_planetary_atmos(atmos)
		qdel(atmos)
	var/datum/ore_node_seeder/ore_node_seeder_instance
	if(ore_node_seeder)
		ore_node_seeder_instance = new ore_node_seeder
	for(var/datum/virtual_level/iterated_vlevel in mapzone.virtual_levels)
		if(ore_node_seeder_instance)
			ore_node_seeder_instance.SeedToLevel(iterated_vlevel)
	if(rock_color)
		mapzone.rock_color = pick(rock_color)
	if(plant_color)
		mapzone.plant_color = pick(plant_color)
	if(grass_color)
		mapzone.grass_color = pick(grass_color)
	if(water_color)
		mapzone.water_color = pick(water_color)
	if(plant_color_as_grass)
		mapzone.grass_color = mapzone.plant_color
	if(ore_node_seeder_instance)
		qdel(ore_node_seeder_instance)
	//Apply the weather controller to the levels if able
	if(weather_controller)
		new weather_controller(mapzone)
	if(day_night_controller)
		new day_night_controller(mapzone)

	if(base_map_generator)
		var/datum/base_map_generator/gen = new base_map_generator()
		gen.generate(mapzone)
	if(terrain_generator)
		var/datum/terrain_generator/gen = new terrain_generator()
		gen.generate(mapzone)
	for(var/custom_generator in pre_custom_generators)
		var/datum/custom_generator/gen = new custom_generator()
		gen.generate(mapzone)
	if(ruin_generator)
		var/datum/ruin_generator/gen = new ruin_generator()
		gen.generate(mapzone)
	for(var/custom_generator in post_custom_generators)
		var/datum/custom_generator/gen = new custom_generator()
		gen.generate(mapzone)

	return mapzone


