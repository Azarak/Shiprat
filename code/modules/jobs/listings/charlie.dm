/datum/job_listing_template/charlie
	name = "Charlie Station"
	desc = "Old station"
	access_category = /datum/access_category/charlie
	department_templates = list(
		/datum/job_department_template/charlie,
	)
	job_types = list(
		/datum/job/charlie_scientist,
		/datum/job/charlie_engineer,
		/datum/job/charlie_security_officer
	)

/datum/job_department_template/charlie
	department_name = DEPARTMENT_CIVILLIAN
	department_bitflags = DEPARTMENT_BITFLAG_CIVILLIAN
	department_head = null
	department_experience_type = EXP_TYPE_CIVILLIAN
	display_order = 9
	label_class = "civillian"
	latejoin_color = "#ffffff"
	department_job_types = list(
		/datum/job/charlie_scientist,
		/datum/job/charlie_engineer,
		/datum/job/charlie_security_officer
	)

/datum/access_category/charlie
	name = "Charlie Station"
	define = ACCESS_CATEGORY_OTHER
	access_types = ALL_STATION_ACCESS_TYPES

/datum/job/charlie_scientist
	title = "Scientist"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your survival instinct"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/scientist
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS

/datum/job/charlie_engineer
	title = "Engineer"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your survival instinct"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/engineer
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS

/datum/job/charlie_security_officer
	title = "Security Officer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your survival instinct"
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
