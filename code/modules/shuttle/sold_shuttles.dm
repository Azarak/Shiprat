/datum/sold_shuttle
	/// Name of the shuttle
	var/name = "Shuttle Name"
	/// Description of the shuttle
	var/desc = "Description."
	/// Detailed description of the ship
	var/detailed_desc = "Detailed specifications."
	/// ID of the shuttle
	var/shuttle_id
	/// How much does it cost
	var/cost = 5000
	/// How much left in stock
	var/stock = 2
	/// What type of the shuttle it is. Consoles may have limited purchase range
	var/shuttle_type = SHUTTLE_CIV
	/// Associative to TRUE list of dock id's that this template can fit into
	var/allowed_docks = list()

/datum/sold_shuttle/crow
	name = "ESS Crow"
	desc = "A medium sized exploration shuttle."
	detailed_desc = "It's medium sized and is equipped with four propulsion engines, canisters of co2 and oxygen, a portable generator, excavation gear and some emergency supplies."
	shuttle_id = "exploration_crow"
	cost = 10000
	allowed_docks = list(DOCKS_MEDIUM_UPWARDS)
	shuttle_type = SHUTTLE_EXPLORATION
