/obj/machinery/computer/access
	name = "access chip modification console"
	desc = "Used to modify the priviledges of access chips."
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	light_color = LIGHT_COLOR_BLUE
	circuit = /obj/item/circuitboard/computer/access
	var/obj/item/id_card_chip/inserted_chip = null
	var/obj/item/card/id/inserted_id = null

/obj/item/circuitboard/computer/access
	name = "Access Console (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/access

/obj/machinery/computer/access/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/id_card_chip))
		if(!isnull(inserted_chip))
			inserted_chip.forceMove(loc)
		inserted_chip = weapon
		inserted_chip.forceMove(src)
		return
	if(istype(weapon, /obj/item/card/id))
		if(!isnull(inserted_id))
			inserted_id.forceMove(loc)
		inserted_id = weapon
		inserted_id.forceMove(src)
		return
	return ..()

/obj/machinery/computer/access/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	// Open UI
	show_ui(user)

/obj/machinery/computer/access/proc/show_ui(mob/living/user)
	var/list/dat = list()

	dat += "ID: "
	if(inserted_id)
		dat += "[inserted_id.name] <a href='?src=[REF(src)];task=eject_id'>Eject</a>"
	else
		dat += "None"
	dat += "<BR>ID Chip: "
	if(inserted_chip)
		dat += "[inserted_chip.name] <a href='?src=[REF(src)];task=eject_chip'>Eject</a>"
	else
		dat += "None"

	dat += "<HR>"
	if(!inserted_id)
		dat += "No ID inserted"
	else if (!(ACCESS_CHANGE_IDS in inserted_id.get_access(access_category)))
		dat += "ID doesn't have access priviledges"
	else if (!inserted_chip)
		dat += "No ID chip inserted"
	else if (inserted_chip.category != access_category)
		dat += "Access category of chip is mismatched <a href='?src=[REF(src)];task=update_chip_category'>Update</a>"
	else
		dat += "<table><td valign='top' width='20%'>"
		var/i = 0
		for(var/access_type in access_category.access_types)
			i++
			if(i >= 17)
				dat += "</td><td valign='top' width='25%'>"
				i = 0
			var/datum/access_type/atype = SSid_access.access_types_by_type[access_type]
			dat += "<a [(atype.key in inserted_chip.access) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=toggle_access;key=[atype.key]'>[atype.name]</a><BR>"
		dat += "</td></table>"

	var/datum/browser/popup = new(user, "access_console", "Access Console", 600, 800)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/computer/access/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	var/mob/living/user = usr
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		to_chat(user, SPAN_WARNING("You cannot do this!"))
		return
	switch(href_list["task"])
		if("update_chip_category")
			if(!inserted_id || !inserted_chip || !(ACCESS_CHANGE_IDS in inserted_id.get_access(access_category)))
				return
			inserted_chip.category = access_category
		if("eject_id")
			if(!inserted_id)
				return
			inserted_id.forceMove(loc)
			inserted_id = null
		if("eject_chip")
			if(!inserted_chip)
				return
			inserted_chip.forceMove(loc)
			inserted_chip = null
		if("toggle_access")
			if(!inserted_id || !inserted_chip || !(ACCESS_CHANGE_IDS in inserted_id.get_access(access_category)))
				return
			var/access_key = text2num(href_list["key"])
			if(access_key in inserted_chip.access)
				inserted_chip.access -= access_key
			else
				inserted_chip.access += access_key
	show_ui(user)

/obj/machinery/computer/access/deconstruct(disassembled, mob/user)
	if(inserted_chip)
		inserted_chip.forceMove(loc)
	if(inserted_id)
		inserted_id.forceMove(loc)
	return ..()

/obj/machinery/computer/access/Destroy()
	if(inserted_chip)
		QDEL_NULL(inserted_chip)
	if(inserted_id)
		QDEL_NULL(inserted_id)
	return ..()
