class_name AbilityRoll extends NumberRoll

## Running raw damage.
var base_damage = 0.0 as float
## Additive damage multipliers.
var damage_mult = 0.0 as float

## Running crit chance.
var crit_chance = 0.0 as float
## Running crit mult.
var crit_damage_mult = 0.0 as float

## Base multishot chance (some abilities may fire multiple projectiles,
## so they should gain more multishot than other abilities from buffs).
var base_multishot = 0.0 as float
## Additive multishot multipliers.
var multishot_mult = 0.0 as float

## Additive range multipliers.
var range_mult = 0.0 as float
## Additive duration multipliers.
var duration_mult = 0.0 as float
## Additive cooldown multipliers.
var cooldown_mult = 0.0 as float

# Final numbers

var final_damage = 0.0 as float
var final_multishot = 1 as int

var final_range_mult = 1.0 as float
var final_duration_mult = 1.0 as float
var final_cooldown_mult = 1.0 as float

func finalize_numbers() -> void:
	if finalized:
		return
	
	final_damage = base_damage
	
	var crit_roll = Compute.roll_int(crit_chance)
	final_damage += base_damage * crit_roll * (1.0 + crit_damage_mult)
	
	final_damage *= (1.0 + damage_mult)
	
	final_multishot = Compute.roll_int(base_multishot * (1.0 + multishot_mult))
	
	final_range_mult = 1.0 + range_mult
	final_duration_mult = 1.0 + duration_mult
	final_cooldown_mult = 1.0 + cooldown_mult
	
	finalized = true

func get_final_damage() -> float:
	finalize_numbers()
	return final_damage

func get_final_multishot() -> int:
	finalize_numbers()
	return final_multishot

func get_final_range() -> float:
	finalize_numbers()
	return final_range_mult

func get_final_duration() -> float:
	finalize_numbers()
	return final_duration_mult

func get_final_cooldown() -> float:
	finalize_numbers()
	return final_cooldown_mult
