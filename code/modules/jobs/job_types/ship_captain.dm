/datum/job/ship_captain
	title = "Ship Captain"
	total_positions = 3
	spawn_positions = 3
	supervisors = "yourself"
	selection_color = "#806d567a"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/ship_captain
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/flask/gold)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 10
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/ship_captain
	name = "Ship Captain"
	jobtype = /datum/job/ship_captain
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/e_gun/mini = 1, /obj/item/stack/spacecash/c10000 = 2)
	id_chips = list(/obj/item/id_card_chip/station_job/assistant)
