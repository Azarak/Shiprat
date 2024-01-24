/datum/job_listing
	/// Template ref of the job listing
	var/datum/job_listing_template/template_ref
	/// List of jobs
	var/list/jobs = list()
	/// Assoc list that gets populated from a template information, including jobs inside the listing
	var/list/jobs_by_type = list()
	/// Assoc list of jobs, but this type associated by name
	var/list/jobs_by_name = list()
	/// Departments that get populated from template information.
	var/list/departments = list()
	/// List of landmarks for job spawn positions
	var/list/job_spawn_landmarks = list()
	/// List of generic spawn positions to be used in case people dont have a job landmark
	var/list/spawn_landmarks = list()
	/// List of landmarks for latejoin positions
	var/list/latejoin_landmarks = list()
	/// Unique ID of the job listing, ex "station", or "station_copy"
	var/id = ""
	var/datum/access_category/access_category = null

/datum/job_listing/proc/get_roundstart_spawn_point_for_job(datum/job/job)
	for(var/obj/effect/landmark/start/start as anything in job_spawn_landmarks)
		if(start.job_type != job.type)
			continue
		if(start.used == TRUE)
			continue
		start.used = TRUE
		return start.loc
	for(var/obj/effect/landmark/start/start as anything in spawn_landmarks)
		if(start.used == TRUE)
			continue
		start.used = TRUE
		return start.loc

/datum/job_listing/proc/get_latejoin_spawn_point_for_job(datum/job/job)
	if(latejoin_landmarks.len == 0)
		return null
	return pick(latejoin_landmarks)

/datum/job_listing/proc/shuffle_landmarks()
	//TODO
	return

/datum/job_listing/proc/setup(template_type)
	template_ref = SSjob.job_listing_templates[template_type]
	if(template_ref.access_category)
		access_category = SSid_access.create_access_category(template_ref.access_category)

	if(template_ref.id == null)
		id = template_ref.name
	else
		id = template_ref.id

	for(var/job_type in template_ref.job_types)
		var/datum/job/job = new job_type()
		jobs += job
		jobs_by_name[job.title] = job
		jobs_by_type[job_type] = job
		job.setup(src)

	for(var/department_type in template_ref.department_templates)
		var/datum/job_department/department = new /datum/job_department()
		departments += department
		department.setup(department_type)

		for(var/job_type in department.template_ref.department_job_types)
			var/datum/job/job = jobs_by_type[job_type]
			if(job == null)
				continue
			department.department_jobs += job
			job.departments_list += department

		if(department.template_ref.department_head)
			var/datum/job/head_job = jobs_by_type[department.template_ref.department_head]
			if(head_job)
				department.department_head = head_job


/datum/job_listing/proc/get_department_by_template_type(template_type)
	return
