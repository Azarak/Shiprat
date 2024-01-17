/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards and access
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

	/// The roundstart generated code for the spare ID safe. This is given to the Captain on shift start. If there's no Captain, it's given to the HoP. If there's no HoP
	var/spare_id_safe_code = ""

/datum/controller/subsystem/id_access/Initialize(timeofday)

	spare_id_safe_code = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

	return ..()
