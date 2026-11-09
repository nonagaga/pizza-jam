class_name AbilityRollModifier extends Resource

## Running raw damage.
@export var base_damage = 0.0 as float
## Additive damage multipliers.
@export var damage_mult = 0.0 as float

## Running crit chance.
@export var crit_chance = 0.0 as float
## Running crit mult.
@export var crit_damage_mult = 0.0 as float

## Base multishot chance (some abilities may fire multiple projectiles,
## so they should gain more multishot than other abilities from buffs).
@export var base_multishot = 0.0 as float
## Additive multishot multipliers.
@export var multishot_mult = 0.0 as float

## Additive range multipliers.
@export var range_mult = 0.0 as float
## Additive duration multipliers.
@export var duration_mult = 0.0 as float
## Additive cooldown multipliers.
@export var cooldown_mult = 0.0 as float

func generate_ability_roll() -> AbilityRoll:
	var ar = AbilityRoll.new()
	return modify_ability_roll(ar)

func modify_ability_roll(ar: AbilityRoll) -> AbilityRoll:
	ar.base_damage = base_damage
	ar.damage_mult += damage_mult
	
	ar.crit_chance += crit_chance
	ar.crit_damage_mult += crit_damage_mult
	
	ar.base_multishot += base_multishot
	ar.multishot_mult += multishot_mult
	
	ar.range_mult += range_mult
	ar.duration_mult += duration_mult
	ar.cooldown_mult += cooldown_mult
	
	return ar
