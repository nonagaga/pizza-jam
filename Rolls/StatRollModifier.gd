class_name StatRollModifier extends Resource

## Additive bonus to max health.
@export var max_health_bonus = 0.0 as float
## Additive mult to max health.
@export var max_health_mult = 0.0 as float

## Instant healing (for pickups).
@export var instant_healing = 0.0 as float

## Additive bonus to walk speed.
@export var walk_speed_bonus = 0.0 as float
## Additive mult to walk speed.
@export var walk_speed_mult = 0.0 as float

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	stroll.max_health_bonus += max_health_bonus
	stroll.max_health_mult += max_health_mult
	
	stroll.instant_healing = instant_healing
	
	stroll.walk_speed_bonus += walk_speed_bonus
	stroll.walk_speed_mult += walk_speed_mult
	
	return stroll
