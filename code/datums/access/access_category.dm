/datum/access_category
	var/name = "ACCESS CATEGORY NAME"
	var/define = ""
	var/list/access_types = list()

/datum/access_category/station
	name = "Station"
	define = ACCESS_CATEGORY_STATION
	access_types = ALL_STATION_ACCESS_TYPES
