extends Node

enum Type {
	WEAPON = 0,
	PERK = 1
}

enum Property{
	COST = 999,
	PRODUCTION_TIME = 1001
}

# Weapons

enum Weapon {
	MACHINE_GUN,
	LASER_GUN,
	PROTON_GUN,
	GUN4,
	GUN5,
	GUN6
}

enum WeaponProperty {
	NAME,
	ICON,
	DAMAGE,
	FIRE_RATE,
	CRITICAL_CHANCE
}

const WeaponRef = {
	Weapon.MACHINE_GUN: {
		WeaponProperty.NAME: "Machine gun",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun1.tres"),
		WeaponProperty.DAMAGE: 1.0,
		WeaponProperty.FIRE_RATE: 1.0,
		WeaponProperty.CRITICAL_CHANCE: .05,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .25
	},
	Weapon.LASER_GUN: {
		WeaponProperty.NAME: "Laser gun",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun2.tres"),
		WeaponProperty.DAMAGE: 1.33,
		WeaponProperty.FIRE_RATE: 1.2,
		WeaponProperty.CRITICAL_CHANCE: .1,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .33
	},
	Weapon.PROTON_GUN: {
		WeaponProperty.NAME: "Proton gun",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun3.tres"),
		WeaponProperty.DAMAGE: 1.75,
		WeaponProperty.FIRE_RATE: 1.3,
		WeaponProperty.CRITICAL_CHANCE: .1,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .47
	},
	Weapon.GUN4: {
		WeaponProperty.NAME: "Gun #4",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun4.tres"),
		WeaponProperty.DAMAGE: 2.1,
		WeaponProperty.FIRE_RATE: 1.2,
		WeaponProperty.CRITICAL_CHANCE: .1,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .52
	},
	Weapon.GUN4: {
		WeaponProperty.NAME: "Gun #5",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun5.tres"),
		WeaponProperty.DAMAGE: 2.5,
		WeaponProperty.FIRE_RATE: 1.2,
		WeaponProperty.CRITICAL_CHANCE: .1,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .73
	},
	Weapon.GUN4: {
		WeaponProperty.NAME: "Gun #6",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun6.tres"),
		WeaponProperty.DAMAGE: 2.75,
		WeaponProperty.FIRE_RATE: 1.2,
		WeaponProperty.CRITICAL_CHANCE: .1,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .56
	}
}

# Perks

enum PerkProperty {
	NAME,
	ICON,
	SPEED,
	ARMOR,
	PRODUCTION_TIME
}

enum Perk {
	MOBILITY_1,
	ARMOR_1
}

const PerkRef = {
	Perk.MOBILITY_1: {
		PerkProperty.NAME: "Moobster",
		PerkProperty.ICON: preload("res://sprites/res/upgrade_icons/perks/perk1.tres"),
		PerkProperty.SPEED: 0.05,
		PerkProperty.ARMOR: 0.00,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .05
	},
	Perk.ARMOR_1: {
		PerkProperty.NAME: "Armster",
		PerkProperty.ICON: preload("res://sprites/res/upgrade_icons/perks/perk2.tres"),
		PerkProperty.SPEED: 0.00,
		PerkProperty.ARMOR: 0.03,
		Property.COST: 50,
		Property.PRODUCTION_TIME: .089
	},
}

func get_upgrade_property(upgrade_property, upgrade_type, upgrade_id):
	match upgrade_type:
		Type.WEAPON:
			return WeaponRef[upgrade_id][upgrade_property]
		Type.PERK:
			return PerkRef[upgrade_id][upgrade_property]

