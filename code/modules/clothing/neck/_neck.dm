/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck.dmi'
	worn_icon = 'icons/mob/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40
	fitted_bodytypes = NONE

/obj/item/clothing/neck/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(body_parts_covered & HEAD)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
		if(HAS_BLOOD_DNA(src))
			. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	inhand_icon_state = "" //no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_EASY

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "loose tie"
	desc = "A loosely tied necktie, a perfect accessory for the over-worked detective."
	icon_state = "detective"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(SPAN_SUICIDE("[user] puts \the [src] to [user.p_their()] chest! It looks like [user.p_they()] won't hear much!"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || !isliving(user))
		return ..()
	if(user.combat_mode)
		return

	var/mob/living/carbon/carbon_patient = M
	var/body_part = parse_zone(user.zone_selected)

	var/heart_strength = SPAN_DANGER("no")
	var/lung_strength = SPAN_DANGER("no")

	var/obj/item/organ/heart/heart = carbon_patient.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/lungs/lungs = carbon_patient.getorganslot(ORGAN_SLOT_LUNGS)

	if(carbon_patient.stat != DEAD && !(HAS_TRAIT(carbon_patient, TRAIT_FAKEDEATH)))
		if(istype(heart))
			heart_strength = (heart.beating ? "a healthy" : SPAN_DANGER("an unstable"))
		if(istype(lungs))
			lung_strength = ((carbon_patient.failed_last_breath || carbon_patient.losebreath) ? SPAN_DANGER("strained") : "healthy")

	user.visible_message(SPAN_NOTICE("[user] places [src] against [carbon_patient]'s [body_part] and listens attentively."), ignored_mobs = user)

	var/diagnosis = (body_part == BODY_ZONE_CHEST ? "You hear [heart_strength] pulse and [lung_strength] respiration" : "You faintly hear [heart_strength] pulse")
	if(!user.can_hear())
		diagnosis = "Fat load of good it does you though, since you can't hear"

	to_chat(user, SPAN_NOTICE("You place [src] against [carbon_patient]'s [body_part]. [diagnosis]."))

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "white scarf"
	icon_state = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	w_class = WEIGHT_CLASS_TINY
	dog_fashion = /datum/dog_fashion/head
	custom_price = PAYCHECK_EASY

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "pink scarf"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "striped red scarf"
	icon_state = "stripedredscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = "It's for pets."
	icon_state = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!ismonkey(M))
		return FALSE
	return ..()

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = sanitize_name(stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN))
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = "Damn, it feels good to be a gangster."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(ITEM_SLOT_NECK) == src)
			to_chat(user, SPAN_WARNING("You can't untie [src] while wearing it!"))
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message(SPAN_NOTICE("You untie [oldName] back into a [newBand.name]."), SPAN_NOTICE("[user] unties [oldName] back into a [newBand.name]."))
		else
			to_chat(user, SPAN_WARNING("You must be holding [src] in order to untie it!"))

/obj/item/clothing/neck/beads
	name = "plastic bead necklace"
	desc = "A cheap, plastic bead necklace. Show team spirit! Collect them! Throw them away! The posibilites are endless!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	custom_materials = (list(/datum/material/plastic = 500))

/obj/item/clothing/neck/beads/Initialize()
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")

/datum/component/storage/concrete/pockets/small/collar
	max_items = 1

/datum/component/storage/concrete/pockets/small/collar/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar))

/datum/component/storage/concrete/pockets/small/collar/locked/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar,
	/obj/item/key/collar))

/obj/item/clothing/neck/human_petcollar
	icon = 'icons/horizon/obj/clothing/neck.dmi'
	worn_icon = 'icons/mob/clothing/neck/collars.dmi'
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule. It seems to be made out of a polychromic material."
	icon_state = "petcollar_poly"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar
	var/is_polychromic = TRUE
	var/poly_colors = list("0BB", "FC0", "FFF")
	var/tagname = null
	var/treat_path = /obj/item/food/cookie

/obj/item/clothing/neck/human_petcollar/Initialize()
	. = ..()
	if(treat_path)
		new treat_path(src)

/obj/item/clothing/neck/human_petcollar/ComponentInitialize()
	. = ..()
	if(is_polychromic)
		AddElement(/datum/element/polychromic, poly_colors)

/obj/item/clothing/neck/human_petcollar/attack_self(mob/user)
	tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

/obj/item/clothing/neck/human_petcollar/leather
	name = "leather pet collar"
	icon_state = "leathercollar_poly"
	poly_colors = list("222", "888", "888")

/obj/item/clothing/neck/human_petcollar/choker
	desc = "Quite fashionable... if you're somebody who's just read their first BDSM-themed erotica novel."
	name = "choker"
	icon_state = "choker"
	is_polychromic = FALSE //It's 1 customizable color, can be changed in loadout
	color = "#222222"

/obj/item/clothing/neck/human_petcollar/locked
	name = "locked collar"
	desc = "A collar that has a small lock on it to keep it from being removed."
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar/locked
	treat_path = /obj/item/key/collar
	var/lock = FALSE

/obj/item/clothing/neck/human_petcollar/locked/attackby(obj/item/K, mob/user, params)
	if(istype(K, /obj/item/key))
		var/obj/item/key/key_item = K
		if(key_item.key_id == KEY_ID_COLLAR)
			if(lock != FALSE)
				to_chat(user, SPAN_NOTICE("With a click the collar unlocks!"))
				lock = FALSE
			else
				to_chat(user, SPAN_NOTICE("With a click the collar locks!"))
				lock = TRUE
		else
			to_chat(user, SPAN_WARNING("This key does not fit!"))
		return TRUE
	return ..()

/obj/item/clothing/neck/human_petcollar/locked/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(ITEM_SLOT_NECK) && lock != FALSE)
		to_chat(user, SPAN_WARNING("The collar is locked! You'll need unlock the collar before you can take it off!"))
		return
	..()

/obj/item/clothing/neck/human_petcollar/locked/leather
	name = "leather pet collar"
	icon_state = "leathercollar_poly"
	poly_colors = list("222", "888", "888")

/obj/item/clothing/neck/human_petcollar/locked/choker
	name = "choker"
	desc = "Quite fashionable... if you're somebody who's just read their first BDSM-themed erotica novel."
	icon_state = "choker"
	is_polychromic = FALSE
	color = "#222222"

/obj/item/clothing/neck/cloak/rscloak
	name = "black cape"
	desc = "A black cape with a purple finish at the end."
	icon_state = "black"
	icon = 'icons/obj/clothing/neck/rscapes.dmi'
	worn_icon = 'icons/mob/clothing/neck/rscapes.dmi'

/obj/item/clothing/neck/cloak/rscloak/cross
	name = "black cape"
	desc = "A black cape with a grey cross pattern on the back."
	icon_state = "black_cross"

/obj/item/clothing/neck/cloak/rscloak/champion
	name = "champion cape"
	desc = "A regal blue and gold cape!"
	icon_state = "champion"

/obj/item/clothing/neck/cloak/tailored
	name = "tailored cloak"
	icon_state = "cloak"
	greyscale_config = /datum/greyscale_config/tailored_cloak
	greyscale_config_worn = /datum/greyscale_config/tailored_cloak_worn
	greyscale_colors = "#917A57#4e412e#4e412e"
	fitted_bodytypes = BODYTYPE_HUMANOID|BODYTYPE_TESHARI

/obj/item/clothing/neck/cloak/tailored/veil
	name = "tailored veil"
	greyscale_config = /datum/greyscale_config/tailored_cloak/veil
	greyscale_config_worn = /datum/greyscale_config/tailored_cloak_worn/veil

/obj/item/clothing/neck/cloak/tailored/boat
	name = "tailored boatcloak"
	greyscale_config = /datum/greyscale_config/tailored_cloak/boat
	greyscale_config_worn = /datum/greyscale_config/tailored_cloak_worn/boat

/obj/item/clothing/neck/cloak/tailored/shroud
	name = "tailored shroud"
	greyscale_config = /datum/greyscale_config/tailored_cloak/shroud
	greyscale_config_worn = /datum/greyscale_config/tailored_cloak_worn/shroud
