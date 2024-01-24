///This spawner sets the access of objects on the turf to defined access
/obj/effect/spawner/access
	name = "access helper"
	var/access_define = ACCESS_CATEGORY_LAST_LOADED
	var/list/access = list()

/obj/effect/spawner/access/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/// Spawner that sets the access of objects on the turf to a list represented by string split by semicolons, for mapping varedit usage
/obj/effect/spawner/access_custom
	name = "custom access helper"
	var/access_text = ""

/obj/effect/spawner/access_custom/Initialize()
	..()
	return INITIALIZE_HINT_QDEL
