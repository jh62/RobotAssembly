extends Node

const INVALID_TYPE_OR_PROPERTY := -1

enum Type {
	WEAPON,
	PERK
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
	CRITICAL_CHANCE,
	DOWNSIDES
}

enum PerkProperty {
	NAME,
	ICON,
	SPEED,
	ARMOR,
	DOWNSIDES,
}

enum Perk {
	MOBILITY_1,
	ARMOR_1
}

const WeaponRef = {
	Weapon.MACHINE_GUN: {
		WeaponProperty.NAME: "Heavy machine gun",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun1.tres"),
		WeaponProperty.DAMAGE: 1.5,
		WeaponProperty.FIRE_RATE: .33,
		WeaponProperty.CRITICAL_CHANCE: .025,
		WeaponProperty.DOWNSIDES: {},
		Property.COST: 285,
		Property.PRODUCTION_TIME: .24
	},
	Weapon.LASER_GUN: {
		WeaponProperty.NAME: "Light laser",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun2.tres"),
		WeaponProperty.DAMAGE: .98,
		WeaponProperty.FIRE_RATE: 0.2,
		WeaponProperty.CRITICAL_CHANCE: .05,
		WeaponProperty.DOWNSIDES: {
			PerkProperty.SPEED: -0.05,
			PerkProperty.ARMOR: 0,
		},
		Property.COST: 384,
		Property.PRODUCTION_TIME: .26
	},
	Weapon.PROTON_GUN: {
		WeaponProperty.NAME: "Piercer",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun3.tres"),
		WeaponProperty.DAMAGE: 7.0,
		WeaponProperty.FIRE_RATE: 1.0,
		WeaponProperty.CRITICAL_CHANCE: .015,
		WeaponProperty.DOWNSIDES: {
			PerkProperty.SPEED: 0,
			PerkProperty.ARMOR: 0,
		},
		Property.COST: 285,
		Property.PRODUCTION_TIME: .28
	},
	Weapon.GUN4: {
		WeaponProperty.NAME: "Rocket launcher",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun4.tres"),
		WeaponProperty.DAMAGE: 12,
		WeaponProperty.FIRE_RATE: 1,
		WeaponProperty.CRITICAL_CHANCE: .0115,
		WeaponProperty.DOWNSIDES: {
			PerkProperty.SPEED: 0,
			PerkProperty.ARMOR: 0,
		},
		Property.COST: 403,
		Property.PRODUCTION_TIME: .3
	},
	Weapon.GUN5: {
		WeaponProperty.NAME: "Splitter",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun5.tres"),
		WeaponProperty.DAMAGE: 9,
		WeaponProperty.FIRE_RATE: 1,
		WeaponProperty.CRITICAL_CHANCE: .018,
		WeaponProperty.DOWNSIDES: {
			PerkProperty.SPEED: 0,
			PerkProperty.ARMOR: 0,
		},
		Property.COST: 864,
		Property.PRODUCTION_TIME: .32
	},
	Weapon.GUN6: {
		WeaponProperty.NAME: "Kinetic attack",
		WeaponProperty.ICON: preload("res://sprites/res/upgrade_icons/weapons/gun6.tres"),
		WeaponProperty.DAMAGE: 45,
		WeaponProperty.FIRE_RATE: 2.0,
		WeaponProperty.CRITICAL_CHANCE: .1,
		WeaponProperty.DOWNSIDES: {
			PerkProperty.SPEED: 0,
			PerkProperty.ARMOR: 0,
		},
		Property.COST: 604,
		Property.PRODUCTION_TIME: .7
	}
}

# Perks
const PerkRef = {
	Perk.MOBILITY_1: {
		PerkProperty.NAME: "Mobility I",
		PerkProperty.ICON: preload("res://sprites/res/upgrade_icons/perks/perk1.tres"),
		PerkProperty.SPEED: .05,
		PerkProperty.ARMOR: 0,
		PerkProperty.DOWNSIDES: {
			WeaponProperty.DAMAGE: 0.0,
			WeaponProperty.FIRE_RATE: 0.0,
			WeaponProperty.CRITICAL_CHANCE: -10.0
		},
		Property.COST: 714,
		Property.PRODUCTION_TIME: .07
	},
	Perk.ARMOR_1: {
		PerkProperty.NAME: "Armor I",
		PerkProperty.ICON: preload("res://sprites/res/upgrade_icons/perks/perk2.tres"),
		PerkProperty.SPEED: -0.02,
		PerkProperty.ARMOR: .1,
		PerkProperty.DOWNSIDES: {
			WeaponProperty.DAMAGE: 0.0,
			WeaponProperty.FIRE_RATE: 0.0,
			WeaponProperty.CRITICAL_CHANCE: 0.0
		},
		Property.COST: 1182,
		Property.PRODUCTION_TIME: .011
	},
}

func get_upgrade_property(upgrade_property, upgrade_type, upgrade_id, default_value = null):
	if upgrade_id == -1:
		return default_value

	if Constants.DEBUG_MODE:
		if upgrade_property == Property.COST:
			return 0

	match upgrade_type:
		Type.WEAPON:
			return WeaponRef[upgrade_id][upgrade_property]
		Type.PERK:
			return PerkRef[upgrade_id][upgrade_property]

