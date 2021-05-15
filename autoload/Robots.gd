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
	PRODUCTION_COST,
	PRODUCTION_TIME
}

# Enemy blueprints
const MECH_I = {
	Property.HITPOINTS: 60,
	Property.SPEED: 14,
	Property.DAMAGE: 0,
	Property.FIRE_RATE: 0,
	Property.CRIT_CHANCE: 0,
	Property.WEAPON: Upgrades.Weapon.MACHINE_GUN,
	Property.PERK: -1,
	Property.WEAKNESSES: [Upgrades.Weapon.LASER_GUN],
	Property.PRODUCTION_COST: 0,
	Property.PRODUCTION_TIME: 2.0
}
