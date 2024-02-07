/datum/job_listing_template/bunker
	name = "Bunker"
	desc = "The bunker"
	access_category = /datum/access_category/bunker
	department_templates = list(
		/datum/job_department_template/bunker,
	)
	job_types = list(
		/datum/job/bunker_overseer,
		/datum/job/bunker_civillian
	)

/datum/job_department_template/bunker
	department_name = DEPARTMENT_CIVILLIAN
	department_bitflags = DEPARTMENT_BITFLAG_CIVILLIAN
	department_head = /datum/job/bunker_overseer
	department_experience_type = EXP_TYPE_CIVILLIAN
	display_order = 9
	label_class = "civillian"
	latejoin_color = "#ffffff"
	department_job_types = list(
		/datum/job/bunker_overseer,
		/datum/job/bunker_civillian
	)

/datum/access_category/bunker
	name = "Bunker"
	define = ACCESS_CATEGORY_BUNKER
	access_types = ALL_STATION_ACCESS_TYPES

/datum/job/bunker_civillian
	title = "Civillian"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the overseer"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/assistant
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	family_heirlooms = list(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)

	mail_goodies = list(
		/obj/effect/spawner/lootdrop/donkpockets = 10,
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/gloves/color/fyellow = 7,
		/obj/item/choice_beacon/music = 5,
		/obj/item/toy/sprayoncan = 3,
		/obj/item/crowbar/large = 1
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/job/bunker_overseer
	title = "Overseer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "yourself"
	selection_color = "#806d567a"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/bunker_overseer
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

/datum/outfit/job/bunker_overseer
	name = "Bunker Overseer"
	jobtype = /datum/job/bunker_overseer
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/e_gun/mini = 1, /obj/item/stack/spacecash/c10000 = 2)
	id_chips = list(/obj/item/id_card_chip/station_job/captain)
