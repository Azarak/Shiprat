#define TURF_FIRE_REQUIRED_TEMP (T0C+10)
#define TURF_FIRE_TEMP_BASE (T0C+100)
#define TURF_FIRE_POWER_LOSS_ON_LOW_TEMP 7
#define TURF_FIRE_TEMP_INCREMENT_PER_POWER 3
#define TURF_FIRE_VOLUME 150
#define TURF_FIRE_MAX_POWER 50
#define TURF_FIRE_REQUIRED_POWER_TO_SPREAD 6

#define TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL 12000
#define TURF_FIRE_BURN_RATE_BASE 0.12
#define TURF_FIRE_BURN_RATE_PER_POWER 0.02
#define TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER 0.75
#define TURF_FIRE_POWER_LOSS_PER_SECOND 0.5

#define TURF_FIRE_STATE_SMALL 1
#define TURF_FIRE_STATE_MEDIUM 2
#define TURF_FIRE_STATE_LARGE 3

/obj/effect/abstract/turf_fire
	icon = 'icons/effects/turf_fire.dmi'
	icon_state = "fire_small"
	layer = BELOW_OPEN_DOOR_LAYER
	anchored = TRUE
	move_resist = INFINITY
	light_range = 1.5
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	mouse_opacity = FALSE
	ambience = AMBIENCE_FIRE
	/// How much power have we got. This is treated like fuel, be it flamethrower liquid or any random thing you could come up with
	var/fire_power = 20
	/// Is it magical, if it is then it wont interact with atmos, and it will not loose power by itself. Mainly for adminbus events or mapping
	var/magical = FALSE
	/// Visual state of the fire. Kept track to not do too many updates.
	var/current_fire_state

///All the subtypes are for adminbussery and or mapping
/obj/effect/abstract/turf_fire/magical
	magical = TRUE

/obj/effect/abstract/turf_fire/small
	fire_power = 10

/obj/effect/abstract/turf_fire/small/magical
	magical = TRUE

/obj/effect/abstract/turf_fire/inferno
	fire_power = 30

/obj/effect/abstract/turf_fire/inferno/magical
	magical = TRUE

/obj/effect/abstract/turf_fire/Initialize(mapload, power)
	. = ..()
	var/turf/open/open_turf = loc
	if(open_turf.turf_fire)
		return INITIALIZE_HINT_QDEL
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)
	open_turf.turf_fire = src
	SSturf_fire.fires[src] = TRUE
	if(power)
		fire_power = min(TURF_FIRE_MAX_POWER, power)
	UpdateFireState()

/obj/effect/abstract/turf_fire/Destroy()
	var/turf/open/open_turf = loc
	open_turf.turf_fire = null
	SSturf_fire.fires -= src
	return ..()

/obj/effect/abstract/turf_fire/proc/process_waste()
	var/turf/open/open_turf = loc
	open_turf.pollute_list_turf(list(/datum/pollutant/smoke = 12, /datum/pollutant/carbon_air_pollution = 5), POLLUTION_ACTIVE_EMITTER_CAP)
	if(open_turf.planetary_atmos)
		return TRUE
	var/list/air_gases = open_turf.air?.gases
	if(!air_gases)
		return FALSE
	var/oxy = air_gases[/datum/gas/oxygen] ? air_gases[/datum/gas/oxygen][MOLES] : 0
	if (oxy < 0.5)
		return FALSE
	var/datum/gas_mixture/cached_air = open_turf.air
	var/temperature = cached_air.temperature
	var/old_heat_capacity = cached_air.heat_capacity()
	var/burn_rate = TURF_FIRE_BURN_RATE_BASE + fire_power * TURF_FIRE_BURN_RATE_PER_POWER
	if(burn_rate > oxy)
		burn_rate = oxy
	air_gases[/datum/gas/oxygen][MOLES] = air_gases[/datum/gas/oxygen][MOLES] - burn_rate
	ASSERT_GAS(/datum/gas/carbon_dioxide,cached_air)
	air_gases[/datum/gas/carbon_dioxide][MOLES] += burn_rate * TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER
	var/new_heat_capacity = cached_air.heat_capacity()
	var/energy_released = burn_rate * TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
	cached_air.temperature = (temperature * old_heat_capacity + energy_released) / new_heat_capacity
	open_turf.air_update_turf(TRUE)
	return TRUE

/obj/effect/abstract/turf_fire/process(delta_time)
	var/turf/open/open_turf = loc
	if(!open_turf) //This can happen, how I'm not sure
		qdel(src)
		return
	if(open_turf.liquids)
		var/liquid_power = open_turf.liquids.burn_and_get_power()
		if(liquid_power > 0)
			fire_power += liquid_power
			// Try and spread fires on other liquids if we got extra power from a flammable liquid and fire power is big enough
			if(fire_power >= TURF_FIRE_REQUIRED_POWER_TO_SPREAD)
				for(var/turf/adjacent_turf as anything in open_turf.atmos_adjacent_turfs)
					if(!adjacent_turf.liquids)
						continue
					adjacent_turf.liquids.liquid_hotspot_exposed()

	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead and lets not loose power
		return
	if(!magical)
		if(!process_waste())
			qdel(src)
			return
		if(open_turf.air.temperature < TURF_FIRE_REQUIRED_TEMP)
			fire_power -= TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
		fire_power -= delta_time * TURF_FIRE_POWER_LOSS_PER_SECOND
		if(fire_power <= 0)
			qdel(src)
			return
	open_turf.hotspot_expose(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	for(var/A in open_turf)
		var/atom/AT = A
		AT.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	if(!magical)
		if(prob(fire_power))
			open_turf.burn_tile()
		UpdateFireState()

/obj/effect/abstract/turf_fire/proc/on_entered(datum/source, atom/movable/AM)
	var/turf/open/open_turf = loc
	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead 
		return
	AM.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	return

/obj/effect/abstract/turf_fire/extinguish()
	qdel(src)

/obj/effect/abstract/turf_fire/proc/AddPower(power)
	fire_power = min(TURF_FIRE_MAX_POWER, fire_power + power)
	UpdateFireState()

/obj/effect/abstract/turf_fire/proc/UpdateFireState()
	var/new_state
	switch(fire_power)
		if(0 to 10)
			new_state = TURF_FIRE_STATE_SMALL
		if(11 to 24)
			new_state = TURF_FIRE_STATE_MEDIUM
		if(25 to INFINITY)
			new_state = TURF_FIRE_STATE_LARGE

	if(new_state == current_fire_state)
		return
	current_fire_state = new_state

	switch(current_fire_state)
		if(TURF_FIRE_STATE_SMALL)
			icon_state = "fire_small"
			set_light_range(1.5)
		if(TURF_FIRE_STATE_MEDIUM)
			icon_state = "fire_medium"
			set_light_range(2.5)
		if(TURF_FIRE_STATE_LARGE)
			icon_state = "fire_big"
			set_light_range(3)

#undef TURF_FIRE_REQUIRED_TEMP
#undef TURF_FIRE_TEMP_BASE
#undef TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
#undef TURF_FIRE_TEMP_INCREMENT_PER_POWER
#undef TURF_FIRE_VOLUME
#undef TURF_FIRE_MAX_POWER

#undef TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
#undef TURF_FIRE_BURN_RATE_BASE
#undef TURF_FIRE_BURN_RATE_PER_POWER
#undef TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER

#undef TURF_FIRE_STATE_SMALL
#undef TURF_FIRE_STATE_MEDIUM
#undef TURF_FIRE_STATE_LARGE
