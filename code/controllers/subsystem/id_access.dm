/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards and access
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE
	var/list/access_categories = list()
	var/list/access_types_by_type = list()
	var/datum/access_category/last_category = null
	var/datum/access_category/default_category = null
	var/list/access_list_cache = list()

/datum/controller/subsystem/id_access/Initialize(timeofday)
	populate_access_types()
	return ..()

/datum/controller/subsystem/id_access/proc/populate_access_types()
	for(var/access_type in subtypesof(/datum/access_type))
		access_types_by_type[access_type] = new access_type()

/datum/controller/subsystem/id_access/proc/get_cached_access_list(list/access_list)
	sortTim(access_list, cmp=/proc/cmp_numeric_dsc)
	var/key = ""
	for(var/num in access_list)
		key += "[num]-"
	if(!access_list_cache[key])
		var/list/cached_list = list()
		cached_list += access_list
		access_list_cache[key] = cached_list
	return access_list_cache[key]

/datum/controller/subsystem/id_access/proc/create_access_category(cat_type)
	var/datum/access_category/new_category = new cat_type()
	access_categories += new_category
	last_category = new_category
	if(default_category == null)
		default_category = new_category
	return new_category

/datum/controller/subsystem/id_access/proc/get_access_category_by_define(define)
	if(define == ACCESS_CATEGORY_LAST_LOADED)
		return last_category
	if(define == ACCESS_CATEGORY_DEFAULT)
		return default_category
	for(var/datum/access_category/category as anything in access_categories)
		if(category.define != define)
			continue
		return category
