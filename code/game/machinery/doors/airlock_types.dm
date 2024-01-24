/*
	Station Airlocks Regular
*/

/obj/machinery/door/airlock/command
	assemblytype = /obj/structure/door_assembly/door_assembly_com
	normal_integrity = 450
	airlock_paint = "#334E6D"
	stripe_paint = "#43769D"

/obj/machinery/door/airlock/security
	assemblytype = /obj/structure/door_assembly/door_assembly_sec
	normal_integrity = 450
	airlock_paint = "#9F2828"
	stripe_paint = "#D27428"

/obj/machinery/door/airlock/engineering
	assemblytype = /obj/structure/door_assembly/door_assembly_eng
	airlock_paint = "#A28226"
	stripe_paint = "#7F292F"

/obj/machinery/door/airlock/medical
	assemblytype = /obj/structure/door_assembly/door_assembly_med
	airlock_paint = "#BBBBBB"
	stripe_paint = "#5995BA"

/obj/machinery/door/airlock/maintenance
	name = "maintenance access"
	assemblytype = /obj/structure/door_assembly/door_assembly_mai
	normal_integrity = 250
	stripe_paint = "#B69F3C"

/obj/machinery/door/airlock/maintenance/external
	name = "external airlock access"
	assemblytype = /obj/structure/door_assembly/door_assembly_extmai
	stripe_paint = "#9F2828"

/obj/machinery/door/airlock/mining
	name = "mining airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_min
	airlock_paint = "#967032"
	stripe_paint = "#5F350B"

/obj/machinery/door/airlock/atmos
	name = "atmospherics airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_atmo
	airlock_paint = "#A28226"
	stripe_paint = "#469085"

/obj/machinery/door/airlock/research
	assemblytype = /obj/structure/door_assembly/door_assembly_research
	airlock_paint = "#BBBBBB"
	stripe_paint = "#563758"

/obj/machinery/door/airlock/freezer
	name = "freezer airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_fre
	airlock_paint = "#BBBBBB"

/obj/machinery/door/airlock/science
	assemblytype = /obj/structure/door_assembly/door_assembly_science
	airlock_paint = "#BBBBBB"
	stripe_paint = "#6633CC"

/obj/machinery/door/airlock/virology
	assemblytype = /obj/structure/door_assembly/door_assembly_viro
	airlock_paint = "#BBBBBB"
	stripe_paint = "#2a7a25"

//////////////////////////////////
/*
	Station Airlocks Glass
*/

/obj/machinery/door/airlock/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE

/obj/machinery/door/airlock/glass/incinerator/syndicatelava_interior
	name = "Turbine Interior Airlock"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/glass/incinerator/syndicatelava_exterior
	name = "Turbine Exterior Airlock"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR

/obj/machinery/door/airlock/command/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/airlock/engineering/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/engineering/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/airlock/security/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/airlock/medical/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/research/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/research/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_access = list(ACCESS_TOXINS)

/obj/machinery/door/airlock/research/glass/incinerator/toxmix_interior
	name = "Mixing Room Interior Airlock"
	id_tag = INCINERATOR_TOXMIX_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/research/glass/incinerator/toxmix_exterior
	name = "Mixing Room Exterior Airlock"
	id_tag = INCINERATOR_TOXMIX_AIRLOCK_EXTERIOR

/obj/machinery/door/airlock/mining/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/atmos/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/atmos/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/airlock/science/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/virology/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/maintenance/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/maintenance/external/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 200

//////////////////////////////////
/*
	Station Airlocks Mineral
*/

/obj/machinery/door/airlock/gold
	name = "gold airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_gold
	airlock_paint = "#9F891F"

/obj/machinery/door/airlock/gold/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/silver
	name = "silver airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_silver
	airlock_paint = "#C9C9C9"

/obj/machinery/door/airlock/silver/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/diamond
	name = "diamond airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_diamond
	normal_integrity = 1000
	explosion_block = 2
	airlock_paint = "#4AB4B4"

/obj/machinery/door/airlock/diamond/glass
	normal_integrity = 950
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/uranium
	name = "uranium airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_uranium
	airlock_paint = "#174207"
	var/last_event = 0

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	radiation_pulse(get_turf(src), 150)
	return

/obj/machinery/door/airlock/uranium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/plasma
	name = "plasma airlock"
	desc = "No way this can end badly."
	assemblytype = /obj/structure/door_assembly/door_assembly_plasma
	airlock_paint = "#65217B"

/obj/machinery/door/airlock/plasma/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)

/obj/machinery/door/airlock/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return (exposed_temperature > 300)

/obj/machinery/door/airlock/plasma/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	PlasmaBurn()

/obj/machinery/door/airlock/plasma/proc/PlasmaBurn()
	atmos_spawn_air("plasma=500;TEMP=1000")
	var/obj/structure/door_assembly/DA
	DA = new /obj/structure/door_assembly(loc)
	if(glass)
		DA.glass = TRUE
	if(heat_proof)
		DA.heat_proof_finished = TRUE
	DA.update_appearance()
	DA.update_name()
	qdel(src)

/obj/machinery/door/airlock/plasma/BlockSuperconductivity() //we don't stop the heat~
	return 0

/obj/machinery/door/airlock/plasma/attackby(obj/item/C, mob/user, params)
	if(C.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma airlock ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("Plasma airlock ignited by [key_name(user)] in [AREACOORD(src)]")
		ignite(C.get_temperature())
	else
		return ..()

/obj/machinery/door/airlock/plasma/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/bananium
	name = "bananium airlock"
	desc = "Honkhonkhonk"
	assemblytype = /obj/structure/door_assembly/door_assembly_bananium
	doorOpen = 'sound/items/bikehorn.ogg'
	airlock_paint = "#FFFF00"

/obj/machinery/door/airlock/bananium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/sandstone
	name = "sandstone airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_sandstone
	airlock_paint = "#C09A72"

/obj/machinery/door/airlock/sandstone/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/wood
	name = "wooden airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_wood
	airlock_paint = "#805F44"

/obj/machinery/door/airlock/wood/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/titanium
	name = "shuttle airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_titanium
	airlock_paint = "#b3c0c7"
	normal_integrity = 400

/obj/machinery/door/airlock/titanium/glass
	normal_integrity = 350
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/bronze
	name = "bronze airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze
	airlock_paint = "#9c5f05"

/obj/machinery/door/airlock/bronze/seethru
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze/seethru
	opacity = FALSE
	glass = TRUE
//////////////////////////////////
/*
	Station2 Airlocks
*/

/obj/machinery/door/airlock/public
	icon = 'icons/obj/doors/airlocks/station2/airlock.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/station2/glass_overlays.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_public

/obj/machinery/door/airlock/public/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/public/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS)

/obj/machinery/door/airlock/public/glass/incinerator/atmos_interior
	name = "Turbine Interior Airlock"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/public/glass/incinerator/atmos_exterior
	name = "Turbine Exterior Airlock"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_EXTERIOR

//////////////////////////////////
/*
	External Airlocks
*/

/obj/machinery/door/airlock/external
	name = "external airlock"
	icon = 'icons/obj/doors/airlocks/external/airlock.dmi'
	color_overlays = 'icons/obj/doors/airlocks/external/airlock_color.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/external/glass_overlays.dmi'
	overlays_file = 'icons/obj/doors/airlocks/external/overlays.dmi'
	airlock_paint = "#9F2828"
	assemblytype = /obj/structure/door_assembly/door_assembly_ext

/obj/machinery/door/airlock/external/glass
	opacity = FALSE
	glass = TRUE

//////////////////////////////////
/*
	CentCom Airlocks
*/

/obj/machinery/door/airlock/centcom //Use grunge as a station side version, as these have special effects related to them via phobias and such.
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom
	normal_integrity = 1000
	security_level = 6
	explosion_block = 2

/obj/machinery/door/airlock/grunge
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_grunge

//////////////////////////////////
/*
	Vault Airlocks
*/

/obj/machinery/door/airlock/vault
	name = "vault door"
	icon = 'icons/obj/doors/airlocks/vault/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/vault/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_vault
	explosion_block = 2
	normal_integrity = 400 // reverse engieneerd: 400 * 1.5 (sec lvl 6) = 600 = original
	security_level = 6
	has_fill_overlays = FALSE

//////////////////////////////////
/*
	Hatch Airlocks
*/

/obj/machinery/door/airlock/hatch
	name = "airtight hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_hatch

/obj/machinery/door/airlock/maintenance_hatch
	name = "maintenance hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	stripe_paint = "#B69F3C"
	assemblytype = /obj/structure/door_assembly/door_assembly_mhatch

//////////////////////////////////
/*
	High Security Airlocks
*/

/obj/machinery/door/airlock/highsecurity
	name = "high tech security airlock"
	icon = 'icons/obj/doors/airlocks/highsec/airlock.dmi'
	color_overlays = null
	stripe_overlays = null
	has_fill_overlays = FALSE
	assemblytype = /obj/structure/door_assembly/door_assembly_highsecurity
	explosion_block = 2
	normal_integrity = 500
	security_level = 1
	damage_deflection = 30

//////////////////////////////////
/*
	Shuttle Airlocks
*/

/obj/machinery/door/airlock/shuttle
	name = "shuttle airlock"
	airlock_paint = "#b3c0c7"
	assemblytype = /obj/structure/door_assembly/door_assembly_shuttle

/obj/machinery/door/airlock/shuttle/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/abductor
	name = "alien airlock"
	desc = "With humanity's current technological level, it could take years to hack this advanced airlock... or maybe we should give a screwdriver a try?"
	assemblytype = /obj/structure/door_assembly/door_assembly_abductor
	damage_deflection = 30
	explosion_block = 3
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	normal_integrity = 700
	security_level = 1
	airlock_paint = "#333333"
	stripe_paint = "#6633CC"

//////////////////////////////////
/*
	Cult Airlocks
*/

/obj/machinery/door/airlock/cult
	name = "cult airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_cult
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	damage_deflection = 10
	airlock_paint = "#333333"
	stripe_paint = "#610000"
	var/openingoverlaytype = /obj/effect/temp_visual/cult/door
	var/friendly = FALSE
	var/stealthy = FALSE

/obj/machinery/door/airlock/cult/Initialize()
	. = ..()
	new openingoverlaytype(loc)

/obj/machinery/door/airlock/cult/canAIControl(mob/user)
	return (IS_CULTIST(user) && !isAllPowerCut())

/obj/machinery/door/airlock/cult/on_break()
	if(!panel_open)
		panel_open = TRUE

/obj/machinery/door/airlock/cult/isElectrified()
	return FALSE

/obj/machinery/door/airlock/cult/hasPower()
	return TRUE

/obj/machinery/door/airlock/cult/allowed(mob/living/L)
	if(!density)
		return TRUE
	if(friendly || IS_CULTIST(L) || istype(L, /mob/living/simple_animal/shade) || isconstruct(L))
		if(!stealthy)
			new openingoverlaytype(loc)
		return TRUE
	else
		if(!stealthy)
			new /obj/effect/temp_visual/cult/sac(loc)
			var/atom/throwtarget
			throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
			SEND_SOUND(L, sound(pick('sound/hallucinations/turn_around1.ogg','sound/hallucinations/turn_around2.ogg'),0,1,50))
			flash_color(L, flash_color="#960000", flash_time=20)
			L.Paralyze(40)
			L.throw_at(throwtarget, 5, 1,src)
		return FALSE

/obj/machinery/door/airlock/cult/proc/conceal()
	icon = 'icons/obj/doors/airlocks/station/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	name = "airlock"
	desc = "It opens and closes."
	stealthy = TRUE
	update_appearance()

/obj/machinery/door/airlock/cult/proc/reveal()
	icon = initial(icon)
	overlays_file = initial(overlays_file)
	name = initial(name)
	desc = initial(desc)
	stealthy = initial(stealthy)
	update_appearance()

/obj/machinery/door/airlock/cult/narsie_act()
	return

/obj/machinery/door/airlock/cult/emp_act(severity)
	return

/obj/machinery/door/airlock/cult/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/cult/glass/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/unruned
	assemblytype = /obj/structure/door_assembly/door_assembly_cult/unruned
	openingoverlaytype = /obj/effect/temp_visual/cult/door/unruned

/obj/machinery/door/airlock/cult/unruned/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/unruned/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/cult/unruned/glass/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/weak
	name = "brittle cult airlock"
	desc = "An airlock hastily corrupted by blood magic, it is unusually brittle in this state."
	normal_integrity = 150
	damage_deflection = 5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

//////////////////////////////////
/*
	Misc Airlocks
*/

/obj/machinery/door/airlock/glass_large
	name = "large glass airlock"
	icon = 'icons/obj/doors/airlocks/glass_large/glass_large.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	opacity = FALSE
	assemblytype = null
	glass = TRUE
	bound_width = 64 // 2x1

/obj/machinery/door/airlock/glass_large/narsie_act()
	return
