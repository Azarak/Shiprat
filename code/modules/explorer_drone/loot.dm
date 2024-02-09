GLOBAL_LIST_INIT(adventure_loot_generator_index,generate_generator_index())

/// Creates generator__id => type map.
/proc/generate_generator_index()
	. = list()
	for(var/type in typesof(/datum/adventure_loot_generator))
		var/datum/adventure_loot_generator/generator = type
		if(!initial(generator.id))
			continue
		.[initial(generator.id)] = type

/// Adventure loot category identified by ID
/datum/adventure_loot_generator
	var/id

/datum/adventure_loot_generator/proc/generate()
	return

/// Helper to transfer loot while respecting cargo space
/datum/adventure_loot_generator/proc/transfer_loot(obj/item/exodrone/drone)
	for(var/obj/loot in generate())
		drone.try_transfer(loot)

/// Uses manintenance loot generators
/datum/adventure_loot_generator/maintenance
	id = "maint"
	var/amount = 1

/datum/adventure_loot_generator/maintenance/generate()
	var/list/all_loot = list()
	for(var/i in 1 to amount)
		var/lootspawn = pickweight(GLOB.maintenance_loot)
		while(islist(lootspawn))
			lootspawn = pickweight(lootspawn)
		var/atom/movable/loot = new lootspawn()
		all_loot += loot
	return all_loot

/// Unlocks special cargo crates
/datum/adventure_loot_generator/cargo
	id = "trade_contract"

/datum/adventure_loot_generator/cargo/generate()
	return

/// Just picks and instatiates the path from the list
/datum/adventure_loot_generator/simple
	var/loot_list

/datum/adventure_loot_generator/simple/generate()
	var/loot_type = pick(loot_list)
	return list(new loot_type())

/// Unique exploration-only rewards - this is contextless
/datum/adventure_loot_generator/simple/unique
	id = "unique"
	loot_list = list(/obj/item/clothing/glasses/geist_gazers,/obj/item/clothing/glasses/psych,/obj/item/firelance)

/// Valuables
/datum/adventure_loot_generator/simple/cash
	id = "cash"
	loot_list = list(/obj/item/storage/bag/money,/obj/item/antique,/obj/item/stack/spacecash/c1000,/obj/item/holochip/thousand)

/// Drugs
/datum/adventure_loot_generator/simple/drugs
	id = "drugs"
	loot_list = list(/obj/item/storage/pill_bottle/happy,/obj/item/storage/pill_bottle/lsd,/obj/item/storage/pill_bottle/penacid,/obj/item/storage/pill_bottle/stimulant)

/// Rare minerals/materials
/datum/adventure_loot_generator/simple/materials
	id = "materials"
	loot_list = list(/obj/item/stack/sheet/iron/fifty,/obj/item/stack/sheet/plasteel/twenty)

/// Assorted weaponry
/datum/adventure_loot_generator/simple/weapons
	id = "weapons"
	loot_list = list(/obj/item/gun/energy/laser,/obj/item/melee/baton/loaded)

/// Pets and pet accesories in carriers
/datum/adventure_loot_generator/pet
	id = "pets"
	var/carrier_type = /obj/item/pet_carrier/biopod
	var/list/possible_pets = list(/mob/living/simple_animal/pet/cat/space,/mob/living/simple_animal/pet/dog/corgi,/mob/living/simple_animal/pet/penguin/baby,/mob/living/simple_animal/pet/dog/pug)

/datum/adventure_loot_generator/pet/generate()
	var/obj/item/pet_carrier/carrier = new carrier_type()
	var/chosen_pet_type = pick(possible_pets)
	var/mob/living/simple_animal/pet/pet = new chosen_pet_type()
	carrier.add_occupant(pet)
	return carrier

/obj/item/antique
	name = "antique"
	desc = "Valuable and completly incomprehensible."
	icon = 'icons/obj/exploration.dmi'
	icon_state = "antique"

/// Two handed fire lance. Melts wall after short windup.
/obj/item/firelance
	name = "fire lance"
	desc = "Melts everything in front of you. Takes a while to start and operate."
	icon = 'icons/obj/exploration.dmi'
	icon_state = "firelance"
	inhand_icon_state = "firelance"
	righthand_file = 'icons/mob/inhands/misc/firelance_righthand.dmi'
	lefthand_file = 'icons/mob/inhands/misc/firelance_lefthand.dmi'
	var/windup_time = 10 SECONDS
	var/melt_range = 3
	var/charge_per_use = 200
	var/obj/item/stock_parts/cell/cell

/obj/item/firelance/Initialize()
	. = ..()
	cell = new /obj/item/stock_parts/cell(src)
	AddComponent(/datum/component/two_handed)

/obj/item/firelance/attack(mob/living/M, mob/living/user, params)
	if(!user.combat_mode)
		return
	. = ..()

/obj/item/firelance/get_cell()
	return cell

/obj/item/firelance/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!HAS_TRAIT(src,TRAIT_WIELDED))
		to_chat(user,SPAN_NOTICE("You need to wield [src] in two hands before you can fire it."))
		return
	if(LAZYACCESS(user.do_afters, "firelance"))
		return
	if(!cell.use(charge_per_use))
		to_chat(user,SPAN_WARNING("[src] battery ran dry!"))
	ADD_TRAIT(user,TRAIT_IMMOBILIZED,src)
	to_chat(user,SPAN_NOTICE("You begin to charge [src]"))
	inhand_icon_state = "firelance_charging"
	user.update_inv_hands()
	if(do_after(user,windup_time,interaction_key="firelance",extra_checks = CALLBACK(src, .proc/windup_checks)))
		var/turf/start_turf = get_turf(user)
		var/turf/last_turf = get_ranged_target_turf(start_turf,user.dir,melt_range)
		start_turf.Beam(last_turf,icon_state="solar_beam",time=1 SECONDS)
		for(var/turf/turf_to_melt in getline(start_turf,last_turf))
			if(turf_to_melt.density)
				turf_to_melt.Melt()
	inhand_icon_state = initial(inhand_icon_state)
	user.update_inv_hands()
	REMOVE_TRAIT(user,TRAIT_IMMOBILIZED,src)

/// Additional windup checks
/obj/item/firelance/proc/windup_checks()
	return HAS_TRAIT(src,TRAIT_WIELDED)
