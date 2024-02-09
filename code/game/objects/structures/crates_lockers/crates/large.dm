/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty wooden crate. You'll need a crowbar to get it open."
	icon_state = "largecrate"
	density = TRUE
	pass_flags_self = PASSSTRUCTURE
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	integrity_failure = 0 //Makes the crate break when integrity reaches 0, instead of opening and becoming an invisible sprite.
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

	// Stops people from "diving into" a crate you can't open normally
	divable = FALSE

/obj/structure/closet/crate/large/attack_hand(mob/user, list/modifiers)
	add_fingerprint(user)
	to_chat(user, SPAN_WARNING("You need a crowbar to pry this open!"))

/obj/structure/closet/crate/large/attackby(obj/item/W, mob/living/user, params)
	if(W.tool_behaviour == TOOL_CROWBAR)
		user.visible_message(SPAN_NOTICE("[user] pries \the [src] open."), \
			SPAN_NOTICE("You pry open \the [src]."), \
			SPAN_HEAR("You hear splitting wood."))
		playsound(src.loc, 'sound/weapons/slashmiss.ogg', 75, TRUE)

		var/turf/T = get_turf(src)
		for(var/i in 1 to material_drop_amount)
			new material_drop(src)
		for(var/atom/movable/AM in contents)
			AM.forceMove(T)

		qdel(src)

	else
		if(user.combat_mode) //Only return  ..() if intent is harm, otherwise return 0 or just end it.
			return ..() //Stops it from opening and turning invisible when items are used on it.

		else
			to_chat(user, SPAN_WARNING("You need a crowbar to pry this open!"))
			return FALSE //Just stop. Do nothing. Don't turn into an invisible sprite. Don't open like a locker.
					//The large crate has no non-attack interactions other than the crowbar, anyway.

/obj/structure/closet/crate/large/air_can/PopulateContents()
	. = ..()
	new /obj/machinery/portable_atmospherics/canister/air(src)
