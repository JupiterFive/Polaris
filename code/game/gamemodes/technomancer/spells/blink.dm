/datum/technomancer/spell/blink
	name = "Blink"
	desc = "Force the target to teleport a short distance away.  This target could be anything from something lying on the ground, to someone trying to \
	fight you, or even yourself.  Using this on someone next to you makes their potential distance after teleportation greater."
	enhancement_desc = "Blink distance is increased greatly."
	spell_power_desc = "Blink distance is scaled up with more spell power."
	cost = 50
	obj_path = /obj/item/weapon/spell/blink
	category = UTILITY_SPELLS

/obj/item/weapon/spell/blink
	name = "blink"
	desc = "Teleports you or someone else a short distance away."
	icon_state = "blink"
	cast_methods = CAST_RANGED | CAST_MELEE | CAST_USE
	aspect = ASPECT_TELE

/proc/safe_blink(atom/movable/AM, var/range = 3)
	if(AM.anchored || !AM.loc)
		return
	var/turf/starting = get_turf(AM)
	var/list/targets = list()

	valid_turfs:
		for(var/turf/simulated/T in range(AM, range))
			if(T.density || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
				continue
			for(var/atom/movable/stuff in T.contents)
				if(stuff.density)
					continue valid_turfs
			targets.Add(T)

	if(!targets.len)
		return
	var/turf/simulated/destination = null

	destination = pick(targets)

	if(destination)
		if(ismob(AM))
			var/mob/living/L = AM
			if(L.buckled)
				L.buckled.unbuckle_mob()
		AM.forceMove(destination)
		AM.visible_message("<span class='notice'>\The [AM] vanishes!</span>")
		AM << "<span class='notice'>You suddenly appear somewhere else!</span>"
		new /obj/effect/effect/sparks(destination)
		new /obj/effect/effect/sparks(starting)
	return

/obj/item/weapon/spell/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(!within_range(AM))
			user << "<span class='warning'>\The [AM] is too far away to blink.</span>"
			return
		if(check_for_scepter())
			safe_blink(AM, calculate_spell_power(6))
		else
			safe_blink(AM, calculate_spell_power(3))
		log_and_message_admins("has blinked [AM] away.")

/obj/item/weapon/spell/blink/on_use_cast(mob/user)
	if(check_for_scepter())
		safe_blink(user, calculate_spell_power(10))
	else
		safe_blink(user, calculate_spell_power(6))
	log_and_message_admins("has blinked themselves away.")

/obj/item/weapon/spell/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		visible_message("<span class='danger'>\The [user] reaches out towards \the [AM] with a glowing hand.</span>")
		if(check_for_scepter())
			safe_blink(AM, 10)
		else
			safe_blink(AM, 6)
		log_and_message_admins("has blinked [AM] away.")