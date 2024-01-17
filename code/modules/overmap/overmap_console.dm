/obj/machinery/computer/overmap_console
	name = "overmap ops console"
	desc = "An advanced operations control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/overmap_console/ui_interact(mob/user, datum/tgui/ui)
	var/datum/map_zone/mapzone = get_map_zone()
	if(!mapzone.related_overmap_object || !mapzone.related_overmap_object.is_overmap_controllable)
		return
	var/list/dat = list()
	dat += "<center><a href='?src=[REF(src)];task=overmap_view'>Overmap View</a>"
	dat += "<BR><a href='?src=[REF(src)];task=overmap_ship_controls'>Controls</a></center>"
	var/datum/browser/popup = new(user, "overmap_computer", name, 300, 200)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/computer/overmap_console/Topic(href, href_list)
	var/mob/user = usr
	if(!isliving(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	var/datum/map_zone/mapzone = get_map_zone()
	if(!mapzone.related_overmap_object || !mapzone.related_overmap_object.is_overmap_controllable)
		return
	var/datum/overmap_object/shuttle/ov_obj = mapzone.related_overmap_object
	switch(href_list["task"])
		if("overmap_view")
			ov_obj.GrantOvermapView(usr, get_turf(src))
			return
		if("overmap_ship_controls")
			ov_obj.DisplayUI(usr, get_turf(src))
			return
	ui_interact(usr)
