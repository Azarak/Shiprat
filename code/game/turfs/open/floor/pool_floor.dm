/obj/item/stack/tile/plasteel/pool
	name = "pool floor tile"
	icon_state = "pool_tile"
	singular_name = "pool floor tile"
	turf_type = /turf/open/floor/plasteel/pool

/turf/open/floor/plasteel/pool
	name = "pool floor"
	floor_tile = /obj/item/stack/tile/plasteel/pool
	icon = 'icons/turf/pool_tile.dmi'
	base_icon_state = "pool_tile"
	icon_state = "pool_tile"
	liquid_height = -30
	turf_height = -30

/turf/open/floor/plasteel/pool/setup_broken_states()
	return list("pool_tile")

/turf/open/floor/plasteel/pool/setup_burnt_states()
	return list("pool_tile")

/turf/open/floor/plasteel/pool/rust_heretic_act()
	return
