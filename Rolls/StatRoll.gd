class_name StatRoll extends NumberRoll

## Additive bonus to max health.
var max_health_bonus = 0.0 as float
## Additive mult to max health.
var max_health_mult = 0.0 as float

## Additive bonus to walk speed.
var walk_speed_bonus = 0.0 as float
## Additive mult to walk speed.
var walk_speed_mult = 0.0 as float

# Final

var final_max_health = 0.0 as float
var final_walk_speed = 0.0 as float

func finalize_numbers() -> void:
	if finalized:
		return
	
	final_max_health = max_health_bonus * (1.0 + max_health_mult)
	final_max_health = floorf(final_max_health)
	
	final_walk_speed = walk_speed_bonus * (1.0 + walk_speed_mult)
	
	finalized = true

func get_final_max_health() -> float:
	finalize_numbers()
	return final_max_health

func get_final_walk_speed() -> float:
	finalize_numbers()
	return max(0.0, final_walk_speed)
