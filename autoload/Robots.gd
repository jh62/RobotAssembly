extends Node

enum Property {
	NAME,
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
const ROBOT_A1 = {
	Property.NAME: "Centurion",
	Property.HITPOINTS: 20,
	Property.SPEED: 24,
	Property.DAMAGE: 0,
	Property.FIRE_RATE: 0,
	Property.CRIT_CHANCE: 0,
	Property.WEAPON: Upgrade.Weapon.MACHINE_GUN,
	Property.PERK: -1,
	Property.WEAKNESSES: [Upgrade.Weapon.LASER_GUN],
	Property.PRODUCTION_COST: 0,
	Property.PRODUCTION_TIME: 2.0
}

const ROBOT_A2 = {
	Property.NAME: "Pretorian",
	Property.HITPOINTS: 100,
	Property.SPEED: 80,
	Property.DAMAGE: 0,
	Property.FIRE_RATE: 0,
	Property.CRIT_CHANCE: 0,
	Property.WEAPON: Upgrade.Weapon.GUN6,
	Property.PERK: -1,
	Property.WEAKNESSES: [Upgrade.Weapon.GUN6],
	Property.PRODUCTION_COST: 0,
	Property.PRODUCTION_TIME: 4.3
}
