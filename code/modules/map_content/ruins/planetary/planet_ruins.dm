/datum/map_template/ruin/planetary
	prefix = "_maps/RandomRuins/Planet/"
	allow_duplicates = FALSE
	cost = 3

/datum/map_template/ruin/planetary/colony
	name = "Colony"
	id = "colony"
	description = "A colony."
	suffix = "colony.dmm"
	requirements = RUIN_HABITABLE
	unpickable = TRUE

/area/ruin/unpowered/colony

/area/ruin/unpowered/colony/outdoors
	outdoors = TRUE

/area/ruin/unpowered/colony/outdoors/cargo_bay
	name = "Colony Cargo Bay"

/area/ruin/unpowered/colony/external_airlock
	name = "Colony External Airlock"

/area/ruin/unpowered/colony/hallways
	name = "Colony Hallways"

/area/ruin/unpowered/colony/bathroom
	name = "Colony Bathroom"

/area/ruin/unpowered/colony/security
	name = "Colony Security"

/area/ruin/unpowered/colony/armory
	name = "Colony Armory"

/area/ruin/unpowered/colony/atmos
	name = "Colony Atmospherics"

/area/ruin/unpowered/colony/engineering
	name = "Colony Engineering"

/area/ruin/unpowered/colony/dorms
	name = "Colony Dormitories"

/area/ruin/unpowered/colony/mess_hall
	name = "Colony Mess Hall"

/area/ruin/unpowered/colony/medbay
	name = "Colony Medbay"

/area/ruin/unpowered/colony/operating_theatre
	name = "Colony Operating Theatre"

/area/ruin/unpowered/colony/ops
	name = "Colony Operations Center"

/area/ruin/unpowered/colony/secure_storage
	name = "Colony Secure Storage"

/datum/map_template/ruin/planetary/crashed_pod
	name = "Crashed Pod"
	id = "crashed_pod"
	description = "A crashed pod."
	cost = 5
	suffix = "crashed_pod.dmm"
	requirements = RUIN_WRECKAGE

/area/ruin/unpowered/crashed_pod
	name = "Crashed Pod"

/datum/map_template/ruin/planetary/old_pod
	name = "Old Pod"
	id = "old_pod"
	description = "An old pod."
	suffix = "old_pod.dmm"
	requirements = RUIN_WRECKAGE

/datum/map_template/ruin/planetary/deserted_lab
	name = "Deserted Lab"
	id = "deserted_lab"
	description = "A deserted lab."
	suffix = "deserted_lab.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/lodge
	name = "Lodge"
	id = "lodge"
	description = "A lodge."
	suffix = "lodge.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/spider_nest
	name = "Spider Nest"
	id = "spider_nest"
	description = "A spider nest."
	suffix = "spider_nest.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/archeological_site
	name = "Archeological Site"
	id = "archeological_site"
	description = "An archeological site."
	suffix = "archeological_site.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/abandoned_factory
	name = "Abandoned Factory"
	id = "abandoned_factory"
	description = "An abandoned factory."
	suffix = "abandoned_factory.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/old_drill_site
	name = "Old Drill Site"
	id = "old_drill_site"
	description = "An old drill site."
	suffix = "old_drill_site.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/mining_facility
	name = "Mining Facility"
	id = "mining_facility"
	description = "A mining facility."
	suffix = "mining_facility.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/abandoned_containment
	name = "Abandoned Containment"
	id = "abandoned_containment"
	description = "A long abandoned base containing a dangerous secret."
	suffix = "abandoned_containment.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/weather_station
	name = "Weather Station"
	id = "weather_station"
	description = "A dormant weather research station."
	suffix = "weather_station.dmm"
	requirements = RUIN_HABITABLE

/datum/map_template/ruin/planetary/heyheypeople
	name = "Surgical Theatre Pod"
	id = "heyheypeople"
	description = "A pod, meant for surgery.. what's with the pizza?"
	suffix = "heyheypeople.dmm"
	requirements = RUIN_HABITABLE
