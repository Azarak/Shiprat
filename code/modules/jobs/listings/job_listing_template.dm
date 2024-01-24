/datum/job_listing_template
	/// Name of the job listing
	var/name = "JOB LISTING NAME"
	/// Description of the job listing
	var/desc = "JOB LISTING DESC"
	/// ID of the job listing, defaults to `name` if null
	var/id = "Station"
	/// Departments of the job listing
	var/list/department_templates = list()
	/// Job types instantiated in the job listing
	var/list/job_types = list()
	/// Defined used for easy lookup by landmarks and such
	var/define = JOB_LISTING_STATION
	/// Type of the access category to be created for the job listing, doesn't if null
	var/access_category = null

/datum/job_listing_template/hubstation
	name = "Hubstation"
	desc = "The hub station"
	access_category = /datum/access_category/station
	department_templates = list(
		/datum/job_department_template/command,
		/datum/job_department_template/security,
		/datum/job_department_template/cargo,
		/datum/job_department_template/engineering,
		/datum/job_department_template/medical,
		/datum/job_department_template/science,
		/datum/job_department_template/service,
		/datum/job_department_template/civillian,
		/datum/job_department_template/undefined,
		/datum/job_department_template/silicon
	)
	job_types = list(
		//Command
		/datum/job/captain,
		/datum/job/head_of_personnel,
		/datum/job/head_of_security,
		/datum/job/chief_engineer,
		/datum/job/chief_medical_officer,
		/datum/job/quartermaster,
		/datum/job/research_director,
		//Security
		/datum/job/security_officer,
		/datum/job/warden,
		/datum/job/detective,
		//Cargo
		/datum/job/cargo_technician,
		//Engineering
		/datum/job/station_engineer,
		/datum/job/atmospheric_technician,
		//Medical
		/datum/job/doctor,
		/datum/job/paramedic,
		/datum/job/geneticist,
		/datum/job/virologist,
		/datum/job/chemist,
		//Science
		/datum/job/scientist,
		/datum/job/roboticist,
		//Service
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
		//Civillian
		//Undefined
		/datum/job/prisoner,
		/datum/job/assistant,
		/datum/job/ship_captain,
		/datum/job/mercenary,
		//Silicon
		/datum/job/cyborg,
		/datum/job/ai,
	)
