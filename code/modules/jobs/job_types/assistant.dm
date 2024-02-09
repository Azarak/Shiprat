/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	total_positions = 5
	spawn_positions = 5
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/assistant
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	family_heirlooms = list(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant
	id_chips = list(/obj/item/id_card_chip/station_job/assistant)

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/grey
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/grey
	else
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/random
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/random
