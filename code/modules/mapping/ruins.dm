/datum/map_template/ruin/proc/try_to_place(datum/virtual_level/vlevel ,allowed_areas,turf/forced_turf, allow_everywhere = FALSE)
	var/z = vlevel.z_value
	var/sanity = forced_turf ? 1 : PLACEMENT_TRIES
	while(sanity > 0)
		sanity--
		var/width_border = vlevel.mapping_margin + round(width / 2)
		var/height_border = vlevel.mapping_margin + round(height / 2)
		var/turf/central_turf = forced_turf ? forced_turf : locate(rand(vlevel.low_x + width_border, vlevel.high_x - width_border), rand(vlevel.low_y + height_border, vlevel.high_y - height_border), z)
		var/valid = TRUE

		if(!allow_everywhere)
			for(var/turf/check in get_affected_turfs(central_turf,1))
				var/area/new_area = get_area(check)
				valid = FALSE // set to false before we check
				if(check.turf_flags & NO_RUINS)
					break
				for(var/type in allowed_areas)
					if(istype(new_area, type)) // it's at least one of our types so it's whitelisted
						valid = TRUE
						break
				if(!valid)
					break

		if(!valid)
			continue

		testing("Ruin \"[name]\" placed at ([central_turf.x], [central_turf.y], [central_turf.z])")

		load(central_turf,centered = TRUE, clear_existing_turfs = TRUE)
		loaded++

		for(var/turf/T in get_affected_turfs(central_turf, 1))
			T.turf_flags |= NO_RUINS

		new /obj/effect/landmark/ruin(central_turf, src)
		return central_turf

/proc/seedRuins(list/virtual_levels = null, budget = 0, whitelist = list(/area/space), list/potentialRuins)
	if(!virtual_levels || !virtual_levels.len)
		WARNING("No Z levels provided - Not generating ruins")
		return

	for(var/datum/virtual_level/vlevel as anything in virtual_levels)
		var/turf/T = locate(1, 1, vlevel.z_value)
		if(!T)
			WARNING("Z level [vlevel.z_value] does not exist - Not generating ruins")
			return

	var/list/ruins = potentialRuins.Copy()

	var/list/forced_ruins = list() //These go first on the z level associated (same random one by default) or if the assoc value is a turf to the specified turf.
	var/list/ruins_available = list() //we can try these in the current pass

	//Set up the starting ruin list
	for(var/key in ruins)
		var/datum/map_template/ruin/R = ruins[key]
		if(R.cost > budget) //Why would you do that
			continue
		if(R.always_place)
			forced_ruins[R] = -1
		if(R.unpickable)
			continue
		if(R.already_placed)
			continue
		ruins_available[R] = R.placement_weight
	while(budget > 0 && (ruins_available.len || forced_ruins.len))
		var/datum/map_template/ruin/current_pick
		var/forced = FALSE
		var/forced_z //If set we won't pick z level and use this one instead.
		var/forced_turf //If set we place the ruin centered on the given turf
		if(forced_ruins.len) //We have something we need to load right now, so just pick it
			for(var/ruin in forced_ruins)
				current_pick = ruin
				if(isturf(forced_ruins[ruin]))
					var/turf/T = forced_ruins[ruin]
					forced_z = T.z //In case of chained ruins
					forced_turf = T
				else if(forced_ruins[ruin] > 0) //Load into designated z
					forced_z = forced_ruins[ruin]
				forced = TRUE
				break
		else //Otherwise just pick random one
			current_pick = pickweight(ruins_available)

		var/placement_tries = forced_turf ? 1 : PLACEMENT_TRIES //Only try once if we target specific turf
		var/failed_to_place = TRUE
		var/target_z = 0
		var/datum/virtual_level/picked_sub = pick(virtual_levels)
		var/turf/placed_turf //Where the ruin ended up if we succeeded
		outer:
			while(placement_tries > 0)
				placement_tries--
				picked_sub = pick(virtual_levels)
				target_z = picked_sub.z_value
				if(forced_z)
					target_z = forced_z
				if(current_pick.always_spawn_with) //If the ruin has part below, make sure that z exists.
					for(var/v in current_pick.always_spawn_with)
						if(current_pick.always_spawn_with[v] == PLACE_BELOW)
							var/turf/T = locate(1,1,target_z)
							if(!T.below())
								if(forced_z)
									continue outer
								else
									break outer

				placed_turf = current_pick.try_to_place(picked_sub,whitelist,forced_turf)
				if(!placed_turf)
					continue
				else
					failed_to_place = FALSE
					break

		//That's done remove from priority even if it failed
		if(forced)
			//TODO : handle forced ruins with multiple variants
			forced_ruins -= current_pick
			forced = FALSE

		if(failed_to_place)
			for(var/datum/map_template/ruin/R in ruins_available)
				if(R.id == current_pick.id)
					ruins_available -= R
			log_world("Failed to place [current_pick.name] ruin.")
		else
			budget -= current_pick.cost
			if(!current_pick.allow_duplicates)
				for(var/datum/map_template/ruin/R in ruins_available)
					if(R.id == current_pick.id)
						R.already_placed = TRUE
						ruins_available -= R
			if(current_pick.never_spawn_with)
				for(var/blacklisted_type in current_pick.never_spawn_with)
					for(var/possible_exclusion in ruins_available)
						if(istype(possible_exclusion,blacklisted_type))
							ruins_available -= possible_exclusion
			if(current_pick.always_spawn_with)
				for(var/v in current_pick.always_spawn_with)
					for(var/ruin_name in SSmapping.ruins_templates) //Because we might want to add space templates as linked of lava templates.
						var/datum/map_template/ruin/linked = SSmapping.ruins_templates[ruin_name] //why are these assoc, very annoying.
						if(istype(linked,v))
							switch(current_pick.always_spawn_with[v])
								if(PLACE_SAME_Z)
									forced_ruins[linked] = target_z //I guess you might want a chain somehow
								if(PLACE_LAVA_RUIN)
									forced_ruins[linked] = pick(SSmapping.virtual_levels_by_trait(ZTRAIT_LAVA_RUINS))
								if(PLACE_SPACE_RUIN)
									forced_ruins[linked] = pick(SSmapping.virtual_levels_by_trait(ZTRAIT_SPACE_RUINS))
								if(PLACE_DEFAULT)
									forced_ruins[linked] = -1
								if(PLACE_BELOW)
									forced_ruins[linked] = placed_turf.below()

		//Update the available list
		for(var/datum/map_template/ruin/R in ruins_available)
			if(R.cost > budget)
				ruins_available -= R

	log_world("Ruin loader finished with [budget] left to spend.")
