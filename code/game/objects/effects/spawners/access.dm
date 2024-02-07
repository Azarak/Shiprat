///This spawner sets the access of objects on the turf to defined access
/obj/effect/spawner/access
	name = "access helper"
	icon = 'icons/effects/access_spawner.dmi'
	icon_state = "access"
	var/access_define = ACCESS_CATEGORY_LAST_LOADED
	var/list/access = list()

/obj/effect/spawner/access/Initialize()
	..()
	var/datum/access_category/category = SSid_access.get_access_category_by_define(access_define)
	for(var/obj/thing in loc)
		thing.access_category = category
		thing.req_access = access.Copy()
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/access/personnel
	icon_state = "personnel"
	access_define = ACCESS_CATEGORY_LAST_LOADED
	access = list(ACCESS_MAINT_TUNNELS)

/obj/effect/spawner/access/command
	icon_state = "command"
	access_define = ACCESS_CATEGORY_LAST_LOADED
	access = list(ACCESS_HEADS)

/// Spawner that sets the access of objects on the turf to a list represented by string split by semicolons, for mapping varedit usage
/obj/effect/spawner/access_custom
	name = "custom access helper"
	var/access_text = ""

/obj/effect/spawner/access_custom/Initialize()
	..()
	return INITIALIZE_HINT_QDEL
