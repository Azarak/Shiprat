/// Singleton representing a category of jobs forming a department.
/datum/job_department
	/// Template ref of the job department
	var/datum/job_department_template/template_ref
	/// Typepath of the job datum leading this department.
	var/datum/job/department_head = null
	/// Job singleton datums associated to this department. Populated on job initialization.
	var/list/department_jobs = list()


/datum/job_department/proc/setup(template_type)
	template_ref = SSjob.job_department_templates[template_type]
