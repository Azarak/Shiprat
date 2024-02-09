/datum/job/psychologist
	title = "Psychologist"
	department_head = list("Head of Personnel","Chief Medical Officer")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel and the chief medical officer"
	selection_color = "#bbe291"
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/psychologist
	plasmaman_outfit = /datum/outfit/plasmaman/psychologist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_PSYCHOLOGIST

	family_heirlooms = list(/obj/item/storage/pill_bottle)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/psychologist
	name = "Psychologist"
	jobtype = /datum/job/psychologist

	ears = /obj/item/radio/headset/headset_srvmed
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/advanced
	belt = /obj/item/pda/medical
	pda_slot = ITEM_SLOT_BELT
	l_hand = /obj/item/clipboard
	id_chips = list(/obj/item/id_card_chip/station_job/psychologist)

	backpack_contents = list(/obj/item/storage/pill_bottle/mannitol, /obj/item/storage/pill_bottle/psicodine, /obj/item/storage/pill_bottle/paxpsych, /obj/item/storage/pill_bottle/happinesspsych, /obj/item/storage/pill_bottle/lsdpsych)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
