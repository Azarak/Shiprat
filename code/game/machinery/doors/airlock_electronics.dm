/obj/item/electronics/airlock
	name = "airlock electronics"
	req_access = list(ACCESS_MAINT_TUNNELS)
	access_category_define = ACCESS_CATEGORY_LAST_LOADED
	/// A list of all granted accesses
	var/list/accesses = list()
	/// If the airlock should require ALL or only ONE of the listed accesses
	var/one_access = FALSE
	/// Unrestricted sides, or sides of the airlock that will open regardless of access
	var/unres_sides = NONE
	///what name are we passing to the finished airlock
	var/passed_name
	///what string are we passing to the finished airlock as the cycle ID
	var/passed_cycle_id
	/// A holder of the electronics, in case of them working as an integrated part
	var/holder

/obj/item/electronics/airlock/Initialize(mapload)
	. = ..()
	gen_access()

/obj/item/electronics/airlock/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Has a neat <i>selection menu</i> for modifying airlock access levels.")

/obj/item/electronics/airlock/ui_interact(mob/user, datum/tgui/ui)
	var/list/dat = list()
	// One access toggle
	dat += "Require only one access: <a href='?src=[REF(src)];task=switch_one_access'>[one_access ? "Yes" : "No"]</a> "
	// Unres sides toggles
	dat += "Access free sides: "
	dat += "<a [(unres_sides & NORTH) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=switch_unres;side=[NORTH]'>N</a>"
	dat += "<a [(unres_sides & SOUTH) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=switch_unres;side=[SOUTH]'>S</a>"
	dat += "<a [(unres_sides & WEST) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=switch_unres;side=[WEST]'>W</a>"
	dat += "<a [(unres_sides & EAST) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=switch_unres;side=[EAST]'>E</a>"
	// Airlock name selector
	dat += "<BR>"
	dat += "Airlock name: <a href='?src=[REF(src)];task=set_airlock_name'>[passed_name ? passed_name : "Default"]</a> "
	// Cycler ID selector
	dat += "Cycling ID: <a href='?src=[REF(src)];task=set_cycling_id'>[passed_cycle_id ? passed_cycle_id : "None"]</a> "
	// Access category selector
	dat += "<HR>"
	var/i = 0
	for(var/datum/access_category/category in SSid_access.access_categories)
		i++
		dat += "<a [(category == access_category) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=set_category;category=[i]'>[category.name]</a>"
	// Access list toggler
	dat += "<HR><table><td valign='top' width='20%'>"
	i = 0
	for(var/access_type in access_category.access_types)
		i++
		if(i >= 17)
			dat += "</td><td valign='top' width='25%'>"
			i = 0
		var/datum/access_type/atype = SSid_access.access_types_by_type[access_type]
		dat += "<a [(atype.key in accesses) ? "class='linkOn'" : ""] href='?src=[REF(src)];task=toggle_access;key=[atype.key]'>[atype.name]</a><BR>"
	dat += "</td></table>"
	var/datum/browser/popup = new(user, "airlock_electronics", "Airlock Electronics", 600, 600)
	popup.set_content(dat.Join())
	popup.open()

/obj/item/electronics/airlock/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	var/mob/living/user = usr
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		to_chat(user, SPAN_WARNING("You cannot do this!"))
		return
	//handle input
	switch(href_list["task"])
		if("toggle_access")
			var/access_key = text2num(href_list["key"])
			if(access_key in accesses)
				accesses -= access_key
			else
				accesses += access_key
		if("switch_unres")
			var/unres_side = text2num(href_list["side"])
			unres_sides ^= unres_side
		if("set_category")
			var/category_num = text2num(href_list["category"])
			access_category = SSid_access.access_categories[category_num]
		if("set_cycling_id")
			var/new_id = input(user, "Choose cycling ID", "Cycling ID", passed_cycle_id) as null|text
			if(!new_id)
				passed_cycle_id = null
			passed_cycle_id = strip_html_simple(new_id)
		if("switch_one_access")
			one_access = !one_access
		if("set_airlock_name")
			var/new_name = input(user, "Choose airlock name", "Airlock Name", passed_name) as null|text
			if(!new_name)
				passed_name = null
			passed_name = strip_html_simple(new_name)
	//update UI
	ui_interact(usr, null)
