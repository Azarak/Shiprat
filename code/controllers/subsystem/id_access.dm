/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards and access
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

/datum/controller/subsystem/id_access/Initialize(timeofday)
	return ..()
