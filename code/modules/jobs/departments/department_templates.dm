/datum/job_department_template
	/// Department as displayed on different menus.
	var/department_name = "No department assigned"
	/// Bitflags associated to the specific department.
	var/department_bitflags = NONE
	/// Job type of the head role of the department, need to be included in `department_job_types`
	var/department_head = null
	/// Experience granted by playing in a job of this department.
	var/department_experience_type = null
	/// The order in which this department appears on menus, in relation to other departments.
	var/display_order = 0
	/// The header color to be displayed in the ban panel, classes defined in banpanel.css
	var/label_class = "undefineddepartment"
	/// The color used in the latejoin menu.
	var/latejoin_color = "#6681a5"
	/// List of job types that should be included in the job listing template, that are associated with this department
	var/list/department_job_types = list()

/datum/job_department_template/command
	department_name = DEPARTMENT_COMMAND
	department_bitflags = DEPARTMENT_BITFLAG_COMMAND
	department_head = /datum/job/captain
	department_experience_type = EXP_TYPE_COMMAND
	display_order = 1
	label_class = "command"
	latejoin_color = "#ccccff"
	department_job_types = list(
		/datum/job/captain,
		/datum/job/head_of_personnel,
		/datum/job/head_of_security,
		/datum/job/chief_engineer,
		/datum/job/chief_medical_officer,
		/datum/job/quartermaster,
		/datum/job/research_director,
	)


/datum/job_department_template/security
	department_name = DEPARTMENT_SECURITY
	department_bitflags = DEPARTMENT_BITFLAG_SECURITY
	department_head = /datum/job/head_of_security
	department_experience_type = EXP_TYPE_SECURITY
	display_order = 2
	label_class = "security"
	latejoin_color = "#ffdddd"
	department_job_types = list(
		/datum/job/head_of_security,
		/datum/job/security_officer,
		/datum/job/warden,
		/datum/job/detective,
	)


/datum/job_department_template/engineering
	department_name = DEPARTMENT_ENGINEERING
	department_bitflags = DEPARTMENT_BITFLAG_ENGINEERING
	department_head = /datum/job/chief_engineer
	department_experience_type = EXP_TYPE_ENGINEERING
	display_order = 3
	label_class = "engineering"
	latejoin_color = "#ffeeaa"
	department_job_types = list(
		/datum/job/chief_engineer,
		/datum/job/station_engineer,
		/datum/job/atmospheric_technician,
	)


/datum/job_department_template/medical
	department_name = DEPARTMENT_MEDICAL
	department_bitflags = DEPARTMENT_BITFLAG_MEDICAL
	department_head = /datum/job/chief_medical_officer
	department_experience_type = EXP_TYPE_MEDICAL
	display_order = 4
	label_class = "medical"
	latejoin_color = "#ffddf0"
	department_job_types = list(
		/datum/job/chief_medical_officer,
		/datum/job/doctor,
		/datum/job/paramedic,
		/datum/job/geneticist,
		/datum/job/virologist,
		/datum/job/chemist,
	)


/datum/job_department_template/science
	department_name = DEPARTMENT_SCIENCE
	department_bitflags = DEPARTMENT_BITFLAG_SCIENCE
	department_head = /datum/job/research_director
	department_experience_type = EXP_TYPE_SCIENCE
	display_order = 5
	label_class = "science"
	latejoin_color = "#ffddff"
	department_job_types = list(
		/datum/job/research_director,
		/datum/job/doctor,
		/datum/job/scientist,
		/datum/job/roboticist,
	)


/datum/job_department_template/cargo
	department_name = DEPARTMENT_CARGO
	department_bitflags = DEPARTMENT_BITFLAG_CARGO
	department_head = /datum/job/quartermaster
	department_experience_type = EXP_TYPE_SUPPLY
	display_order = 6
	label_class = "supply"
	latejoin_color = "#ddddff"
	department_job_types = list(
		/datum/job/quartermaster,
		/datum/job/cargo_technician,
	)


/datum/job_department_template/service
	department_name = DEPARTMENT_SERVICE
	department_bitflags = DEPARTMENT_BITFLAG_SERVICE
	department_head = /datum/job/head_of_personnel
	department_experience_type = EXP_TYPE_SERVICE
	display_order = 7
	label_class = "service"
	latejoin_color = "#bbe291"
	department_job_types = list(
		/datum/job/head_of_personnel,
		/datum/job/bartender,
		/datum/job/cook,
		/datum/job/botanist,
		/datum/job/chaplain,
		/datum/job/curator,
		/datum/job/janitor,
		/datum/job/lawyer,
		/datum/job/psychologist,
		/datum/job/clown,
		/datum/job/mime,
	)


/datum/job_department_template/silicon
	department_name = DEPARTMENT_SILICON
	department_bitflags = DEPARTMENT_BITFLAG_SILICON
	department_head = /datum/job/ai
	department_experience_type = EXP_TYPE_SILICON
	display_order = 8
	label_class = "silicon"
	latejoin_color = "#ccffcc"
	department_job_types = list(
		/datum/job/ai,
		/datum/job/cyborg,
	)

/datum/job_department_template/civillian
	department_name = DEPARTMENT_CIVILLIAN
	department_bitflags = DEPARTMENT_BITFLAG_CIVILLIAN
	department_head = /datum/job/head_of_personnel
	department_experience_type = EXP_TYPE_CIVILLIAN
	display_order = 9
	label_class = "civillian"
	latejoin_color = "#ffffff"

/datum/job_department_template/undefined
	display_order = 10
	department_job_types = list(
		/datum/job/prisoner,
		/datum/job/assistant,
		/datum/job/ship_captain,
		/datum/job/mercenary,
	)
