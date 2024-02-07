//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	var/config_filename = "_maps/metastation.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/votable = FALSE

	// Config actually from the JSON - should default to Meta
	var/map_name = "Meta Station"


	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"emergency" = "emergency_box")

	var/job_listing_template = /datum/job_listing_template/hubstation
	var/overflow_job = /datum/job/assistant

	/// Dictionary of job sub-typepath to template changes dictionary
	var/job_changes = list()

	/// Type of the global trading hub that will be created
	var/global_trading_hub_type = /datum/trade_hub/worldwide
	/// A lazylist of types of trading hubs to be spawned
	var/localized_trading_hub_types = list(/datum/trade_hub/randomname, /datum/trade_hub/randomname)
	/// The type of the overmap object the station will act as on the overmap
	var/overmap_object_type = /datum/overmap_object/shuttle/station
	var/amount_of_planets_spawned = 1
	var/banned_event_tags = list(TAG_PLANETARY)
	var/map_zone_generator = null

/datum/map_config/New()
	. = ..()

/datum/map_config/proc/get_map_info()
	return "You're on board <b>[map_name]</b>, a top of the class NanoTrasen research station."

/proc/load_map_config(filename = "data/next_map.json", default_to_box, delete_after, error_if_missing = TRUE)
	var/datum/map_config/config
	if (default_to_box)
		config = new /datum/map_config/hubstation()
		return config
	config = LoadConfig(filename, error_if_missing)
	if (!config)
		config = new /datum/map_config/hubstation()  // Fall back to Box
	if (delete_after)
		fdel(filename)
	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	if(!json["map_type"])
		log_world("map_config doesn't have a map_type to point to its config datum!")
		return

	CHECK_EXISTS("map_type")
	var/type_to_load = text2path(json["map_type"])
	var/datum/map_config/config = new type_to_load()
	config.defaulted = FALSE
	config.config_filename = filename
	return config
#undef CHECK_EXISTS

/datum/map_config/proc/MakeNextMap()
	return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")
