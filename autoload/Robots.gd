extends Node

enum Property {
	SIDE,
	HITPOINTS,
	SPEED,
	DAMAGE,
	FIRE_RATE,
	CRIT_CHANCE,
	WEAPON,
	PERK,
	WEAKNESSES,
	ORDERS,
	PRODUCTION_TIME
}

# Player blueprints
const MECH_V2 = {
	Property.HITPOINTS: 30,
	Property.SPEED: 20,
	Property.DAMAGE: 1.0,
	Property.FIRE_RATE: 0.0,
	Property.CRIT_CHANCE: 0.0,
	Property.WEAPON: -1,
	Property.PERK: -1,
	Property.WEAKNESSES: [],
	Property.PRODUCTION_TIME: .33
}

# Enemy blueprints
const MECH_I = {
	Property.HITPOINTS: 30,
	Property.SPEED: 20,
	Property.DAMAGE: 1.0,
	Property.FIRE_RATE: 0.0,
	Property.CRIT_CHANCE: 0.0,
	Property.WEAPON: Upgrades.Weapon.MACHINE_GUN,
	Property.PERK: -1,
	Property.WEAKNESSES: [Upgrades.Weapon.LASER_GUN],
	Property.PRODUCTION_TIME: .33
}
