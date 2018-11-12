/obj/structure/religious
	name = "gravestone"
	desc = "A gravestone made with polished stone."
	icon = 'icons/obj/cross.dmi'
	icon_state = "gravestone"
	var/health = 100
/obj/structure/religious/gravestone
	name = "gravestone"
	desc = "A gravestone made with polished stone."
	icon = 'icons/obj/cross.dmi'
	icon_state = "gravestone"
	density = FALSE
	anchored = TRUE

/obj/structure/religious/totem
	name = "stone totem"
	desc = "A stone statue, representing the spirit animal of this tribe."
	icon = 'icons/obj/cross.dmi'
	icon_state = "goose"
	density = TRUE
	anchored = TRUE
	var/tribe = "goose"
	layer = 3.2

/obj/structure/religious/animal_statue
	name = "statue"
	desc = "A stone statue."
	icon = 'icons/obj/cross.dmi'
	icon_state = "goose"
	density = TRUE
	anchored = TRUE
	layer = 3.2

/obj/structure/religious/animal_statue/New()
	..()
	var/randimg = pick("bear","mouse","goose","wolf","turkey","monkey")
	icon_state = randimg
	name = "[randimg] statue"

/obj/structure/religious/woodcross1
	name = "small wood cross"
	desc = "A small engraved wood cross."
	icon = 'icons/obj/cross.dmi'
	icon_state = "cross1"
	density = FALSE
	anchored = TRUE
	health = 50

/obj/structure/religious/woodcross2
	name = "wood cross"
	desc = "An engraved wood cross."
	icon = 'icons/obj/cross.dmi'
	icon_state = "cross2"
	density = FALSE
	anchored = TRUE
	health = 50

/obj/structure/religious/grave
	name = "open_grave"
	desc = "An opened grave."
	icon = 'icons/obj/cross.dmi'
	icon_state = "grave_overlay"
	density = FALSE
	anchored = TRUE

/obj/structure/religious/impaledskull
	name = "impaled skull"
	desc = "A skull on a spike."
	icon = 'icons/obj/structures.dmi'
	icon_state = "impaledskull"

/obj/structure/religious/tribalmask
	name = "native wood mask"
	desc = "A decorative wood mask."
	icon = 'icons/misc/tribal.dmi'
	icon_state = "tribalmask1"

/obj/structure/religious/remains
	name = "human remains"
	desc = "A bunch of human bones. Spooky."
	icon = 'icons/misc/tribal.dmi'
	icon_state = "remains1"

/obj/structure/religious/remains/New()
	..()
	icon_state = "remains[rand(1,6)]"

/obj/structure/religious/tribalmask/New()
	..()
	icon_state = "tribalmask[rand(1,2)]"

/obj/structure/religious/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	switch(W.damtype)
		if ("fire")
			health -= W.force * 0.3
		if ("brute")
			health -= W.force * 0.3

	playsound(get_turf(src), 'sound/weapons/smash.ogg', 100)
	user.do_attack_animation(src)
	try_destroy()
	..()

/obj/structure/religious/proc/try_destroy()
	if (health <= 0)
		visible_message("<span class='danger'>The [src] is broken into pieces!</span>")
		qdel(src)
		return

/obj/structure/religious/totem/offerings
	icon = 'icons/misc/support.dmi'
	icon_state = "goose"
	bound_height = 64
	var/power = 175
	health = 100000000
	var/datum/job/tribe_job = "/datum/job/indians/tribes/red"
	var/current_tribesmen = 0
/obj/structure/religious/totem/offerings/proc/create_mobs()
	var/I = 0
	while(I < round(current_tribesmen/2))

		var/mob/living/simple_animal/hostile/skeleton/attacker_gods/newmob = new /mob/living/simple_animal/hostile/skeleton/attacker_gods(src.loc)
		newmob.target_loc = loc
		var/randdir = pick(1,2,3,4)
		if (randdir == 1)
			newmob.x=src.x+(rand(-15,15))
			newmob.y=src.y+(rand(12,25))
		else if (randdir == 2)
			newmob.x=src.x+(rand(-15,15))
			newmob.y=src.y+(rand(-12,-25))
		else if (randdir == 3)
			newmob.x=src.x+(rand(-12,-25))
			newmob.y=src.y+(rand(-15,15))
		else
			newmob.x=src.x+(rand(12,25))
			newmob.y=src.y+(rand(-15,15))
		if (istype(get_turf(newmob), /turf/wall) || istype (get_turf(newmob), /turf/floor/dirt/underground) || istype (get_turf(newmob), /turf/floor/plating/beach/water/deep))
			while (istype(get_turf(newmob), /turf/wall) || istype (get_turf(newmob), /turf/floor/dirt/underground) || istype (get_turf(newmob), /turf/floor/plating/beach/water/deep))
				if (randdir == 1)
					newmob.x=src.x+(rand(-15,15))
					newmob.y=src.y+(rand(12,25))
				else if (randdir == 2)
					newmob.x=src.x+(rand(-15,15))
					newmob.y=src.y+(rand(-12,-25))
				else if (randdir == 3)
					newmob.x=src.x+(rand(-12,-25))
					newmob.y=src.y+(rand(-15,15))
				else
					newmob.x=src.x+(rand(12,25))
					newmob.y=src.y+(rand(-15,15))
		I += 1
/obj/structure/religious/totem/offerings/proc/check_favours()
	spawn(1800)
		//very angry
		if (power < 50)
			if (weather == WEATHER_NONE)
				change_weather_somehow()
			visible_message("The gods are angry, sending heavy rains!")
			if (prob(100-power))
				world << "You feel a shill down your spine, something evil is close by..."
				create_mobs()
		//angry
		else if (power >= 50 && power < 100)
			if (prob(100-power))
				visible_message("Heavy winds and rain have destroyed the crops!")
				if (weather == WEATHER_NONE)
					change_weather_somehow()
				for (var/obj/structure/farming/plant/P in range(30,loc))
					P.icon_state = "[P.plant]-dead"
					P.desc = "A dead [P.plant] plant."
					P.name = "dead [P.plant] plant"
					P.stage = 11

		//neutral
		else if (power >= 100 && power < 150)
			//nothing
			world << ""

		//pleased
		else if (power >= 150 && power < 250)
			if (prob(power/250))
				if (weather == WEATHER_RAIN)
					change_weather_somehow()
					visible_message("The gods have blessed us with good weather!")
		//very pleased
		else if (power >= 250)
			if (weather == WEATHER_RAIN)
				change_weather_somehow()
			visible_message("The gods have blessed us with good weather!")
			if (prob(50) && human_clients_mob_list.len>0)
				if (prob(75))
					new /obj/item/weapon/reagent_containers/food/condiment/tealeaves(loc)
					new /obj/item/weapon/reagent_containers/food/condiment/tealeaves(loc)
				else
					new /obj/item/stack/medical/splint(loc)
		if (power > 50)
			for (var/obj/effect/landmark/npctarget/TG in loc)
				qdel(TG)
		check_favours()
		return

/obj/structure/religious/totem/offerings/proc/check_power()
	spawn(600)
		for (var/datum/job/job in job_master.faction_organized_occupations)
			if (istype(job, text2path(tribe_job)))
				current_tribesmen = processes.job_data.get_active_positions(job)
		if (power > 0)
			power = power-(2*current_tribesmen)
		check_power()
		var/pleasedval = "very angry!"
		if (power >= 50 && power < 100)
			pleasedval = "somewhat angry."
		if (power >= 100 && power < 150)
			pleasedval = "neutral."
		if (power >= 150 && power < 250)
			pleasedval = "somewhat pleased."
		if (power >= 250)
			pleasedval = "very pleased!"
		desc = "A [icon_state] stone totem. The gods seem to be [pleasedval]"
		check_power()
		return

/obj/structure/religious/totem/offerings/New()
	..()
	icon_state = tribe
	name = "[tribe] totem"
	desc = "A stone [tribe] totem."

	if (tribe == "goose")
		tribe_job = "/datum/job/indians/tribes/red"
	else if (tribe == "turkey")
		tribe_job = "/datum/job/indians/tribes/blue"
	else if (tribe == "bear")
		tribe_job = "/datum/job/indians/tribes/black"
	else if (tribe == "wolf")
		tribe_job = "/datum/job/indians/tribes/white"
	else if (tribe == "monkey")
		tribe_job = "/datum/job/indians/tribes/green"
	else if (tribe == "mouse")
		tribe_job = "/datum/job/indians/tribes/yellow"

	for (var/datum/job/job in job_master.faction_organized_occupations)
		if (istype(job, text2path(tribe_job)))
			current_tribesmen = processes.job_data.get_active_positions(job)
	check_power()
	check_favours()


/obj/structure/religious/totem/offerings/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/organ))
		power += 75
		if (istype(I, /obj/item/organ/heart))
			power += 25
		visible_message("The gods take [user]'s offering! They are very pleased!")
		new /obj/effect/effect/smoke/fast(loc)
		qdel(I)
		return
	else if (istype(I, /obj/item/stack/teeth) || istype(I, /obj/item/stack/material/tobacco))
		power += I.amount*12
		visible_message("The gods take [user]'s offering! They are pleased!")
		new /obj/effect/effect/smoke/fast(loc)
		qdel(I)
		return
	else if (istype(I, /obj/item/weapon/reagent_containers/food/snacks))
		power += 10
		visible_message("The gods take [user]'s offering! They are pleased!")
		new /obj/effect/effect/smoke/fast(loc)
		qdel(I)
		return
	..()

/obj/structure/religious/totem/offerings/attack_hand(mob/user as mob)
	if (user.druggy > 10)
		var/list/display1 = list("Heal (120)", "Cancel")
		var/choice1 = WWinput(user, "Your tribe has [power] favour points. What power do you request?", "Communicating with the Gods", "Cancel", display1)
		if (choice1 == "Cancel")
			return
		if (choice1 == "Heal (120)")
			var/list/closemobs = list("Cancel")
			for (var/mob/living/M in range(3,loc))
				closemobs += M
			var/choice2 = WWinput(user, "Who to heal?", "Healing Power", "Cancel", closemobs)
			if (choice2 == "Cancel")
				return
			else
				if (power >= 120)
					var/mob/living/healed = choice2
					healed.revive()
					power -= 120
					return
				else
					user << "Not enough favour points."
					return
			return
	else
		user << "You failed to communicate with the gods. You need drugs to connect yourself with the astral plane."
		return