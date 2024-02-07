/datum/job_listing_template/merchant_ship
	name = "Merchant Ship"
	desc = "The merchant ship"
	access_category = /datum/access_category/merchant_ship
	department_templates = list(
		/datum/job_department_template/merchant_ship,
	)
	job_types = list(
		/datum/job/trademaster,
		/datum/job/merchant_ship_technician,
		/datum/job/merchant_ship_security
	)

/datum/job_department_template/merchant_ship
	department_name = DEPARTMENT_CIVILLIAN
	department_bitflags = DEPARTMENT_BITFLAG_CIVILLIAN
	department_head = /datum/job/trademaster
	department_experience_type = EXP_TYPE_CIVILLIAN
	display_order = 9
	label_class = "civillian"
	latejoin_color = "#ffffff"
	department_job_types = list(
		/datum/job/trademaster,
		/datum/job/merchant_ship_technician,
		/datum/job/merchant_ship_security
	)

/datum/access_category/merchant_ship
	name = "Merchant Ship"
	define = ACCESS_CATEGORY_OTHER
	access_types = ALL_STATION_ACCESS_TYPES

/datum/job/merchant_ship_technician
	title = "Cargo Technician"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the trademaster"
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


/datum/job/trademaster
	title = "Trademaster"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your morals and the bottom line"
	selection_color = "#806d567a"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/trademaster
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS

/datum/outfit/job/trademaster
	name = "Trademaster"
	jobtype = /datum/job/trademaster
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/gun/energy/e_gun/mini = 1, /obj/item/stack/spacecash/c10000 = 2)
	id_chips = list(/obj/item/id_card_chip/station_job/captain)

/datum/job/merchant_ship_security
	title = "Security Guard"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the trademaster"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/security
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS
