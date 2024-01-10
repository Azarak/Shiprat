//Modelled after the 5x7 mining shuttles
/obj/docking_port/stationary/small
	name = "small dock"
	id = "smalldock"
	width = 7
	dwidth = 3
	height = 5

/obj/docking_port/stationary/medium
	name = "medium dock"
	id = "mediumdock"
	width = 30
	dwidth = 8
	height = 20

/obj/docking_port/stationary/large
	name = "large dock"
	id = "largedock"
	width = 40
	dwidth = 8
	height = 30

/obj/docking_port/stationary/huge
	name = "huge dock"
	id = "hugedock"
	width = 50
	dwidth = 16
	height = 40

// TODO Resize docks
// new dimensions
// medium 30x20 dwidth 8
// large 40x30 dwidth 8
// huge 50x40 dwidth 16
// gigant?

//TODO Mapzone generators
// TODO asteroid level
// TODO strand people on asteroid level
// TODO dynamically spawned/despawned small levels for explorations
// -- ^^^^ For now just spawn 8 "small" levels
// TODO ship graveyard level where abandoned/dead ships automatically are docked to

/obj/machinery/computer/shuttle/common_docks
	circuit = /obj/item/circuitboard/computer/shuttle_common_docks
	possible_destinations = "mediumdock;largedock;hugedock;smalldock"

/obj/item/circuitboard/computer/shuttle_common_docks
	name = "Shuttle Console (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/computer/shuttle/common_docks

/datum/map_template/shuttle/common
	port_id = "common"
	who_can_purchase = null
