/datum/access_category
	var/name = "ACCESS CATEGORY NAME"
	var/define = ""
	var/list/access = list()

/datum/access_category/station
	name = "Station"
	define = ACCESS_CATEGORY_STATION
	access = ALL_STATION_ACCESSES
