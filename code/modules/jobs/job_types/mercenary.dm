/datum/job/mercenary
	title = "Mercenary"
	total_positions = 10
	spawn_positions = 10
	supervisors = "yourself"
	selection_color = "#ac977b7a"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/mercenary
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ASSISTANT

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT

	family_heirlooms = list(/obj/item/pickaxe/mini, /obj/item/shovel)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/mercenary
	name = "Mercenary"
	jobtype = /datum/job/mercenary
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,\
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/pickaxe/mini=1,
		)
	id_chips = list(/obj/item/id_card_chip/station_job/assistant)
