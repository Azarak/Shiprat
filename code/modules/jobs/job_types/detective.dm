/datum/job/detective
	title = "Detective"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/detective
	plasmaman_outfit = /datum/outfit/plasmaman/detective

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_DETECTIVE

	banned_quirks = list(SEC_RESTRICTED_QUIRKS)

	required_languages = IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/bottle/whiskey)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/detective
	name = "Detective"
	jobtype = /datum/job/detective

	belt = /obj/item/pda/detective
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/detective
	neck = /obj/item/clothing/neck/tie/detective
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/det_suit
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/fedora/det_hat
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/lighter
	backpack_contents = list(/obj/item/storage/box/evidence=1,\
		/obj/item/detective_scanner=1,\
		/obj/item/melee/classic_baton=1)
	mask = /obj/item/clothing/mask/cigarette

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/gun/ballistic/revolver/detective, /obj/item/clothing/glasses/sunglasses)
	id_chips = list(/obj/item/id_card_chip/station_job/detective)


/datum/outfit/job/detective/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, datum/access_category/access_category)
	..()
	var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
	if(istype(cig)) //Some species specfic changes can mess this up (plasmamen)
		cig.light("")

	if(visualsOnly)
		return
