/datum/job_listing_template/outlaw_ship
	name = "Outlaw Ship"
	desc = "The outlaw ship"
	access_category = /datum/access_category/outlaw_ship
	department_templates = list(
		/datum/job_department_template/outlaw_ship,
	)
	job_types = list(
		/datum/job/outlaw_ship_captain,
		/datum/job/outlaw_ship_crewmate,
	)

/datum/job_department_template/outlaw_ship
	department_name = DEPARTMENT_CIVILLIAN
	department_bitflags = DEPARTMENT_BITFLAG_CIVILLIAN
	department_head = /datum/job/outlaw_ship_captain
	department_experience_type = EXP_TYPE_CIVILLIAN
	display_order = 9
	label_class = "civillian"
	latejoin_color = "#ffffff"
	department_job_types = list(
		/datum/job/outlaw_ship_captain,
		/datum/job/outlaw_ship_crewmate,
	)

/datum/access_category/outlaw_ship
	name = "Outlaw Ship"
	define = ACCESS_CATEGORY_OTHER
	access_types = ALL_STATION_ACCESS_TYPES

/datum/job/outlaw_ship_captain
	title = "Captain"
	total_positions = 1
	spawn_positions = 1
	supervisors = "nobody"
	selection_color = "#806d567a"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/outlaw_ship_captain
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS

/datum/outfit/job/outlaw_ship_captain
	name = "Outlaw Captain"
	jobtype = /datum/job/outlaw_ship_captain
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/e_gun/mini = 1, /obj/item/stack/spacecash/c10000 = 2)
	id_chips = list(/obj/item/id_card_chip/station_job/captain)

/datum/job/outlaw_ship_crewmate
	title = "Crewmate"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the captain"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/cargo_tech
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS
