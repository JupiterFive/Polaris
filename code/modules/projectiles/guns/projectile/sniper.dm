/obj/item/weapon/gun/projectile/heavysniper
	name = "\improper PTRS-7 rifle"
	desc = "A portable anti-armour rifle fitted with a scope. Fires 14.5mm AP shells."
	icon_state = "heavysniper"
	item_state = "shotgun"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=8;materials=2;syndicate=8"
	caliber = "14.5mm"
	recoil = 2 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	accuracy = -1 //made this not as bad as the LWAP's penalty because only one shot
	var/bolt_open = 0

/obj/item/weapon/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/weapon/gun/projectile/heavysniper/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			user << "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>"
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			user << "<span class='notice'>You work the bolt open.</span>"
	else
		user << "<span class='notice'>You work the bolt closed.</span>"
		bolt_open = 0
	update_icon()

/obj/item/weapon/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		user << "<span class='warning'>You can't fire [src] with the bolt open!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1
	
	toggle_scope(2.0)

//need to override zoom() so that accuracy is properly reset even if we move while zoomed in.
/obj/item/weapon/gun/projectile/heavysniper/zoom()
	..()
	if(zoom)
		accuracy -= initial(accuracy) //remove the accuracy penalty if zoomed in