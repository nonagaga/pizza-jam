## These combat stats should NOT change mid-game.
## Anything that buffs an entity's stats shall be applied SEPARATELY
## to that entity.
class_name EntityCombatStats extends Resource

## Maximum and starting health.
@export var max_health = 100.0 as float
## Additive health per difficulty.
@export var max_health_diff = 0.0 as float

## Normal walk speed.
@export var walk_speed = 3.0 as float
## Additive walk speed per difficulty.
@export var walk_speed_diff = 0.0 as float

func get_walk_speed() -> float:
	return walk_speed * Physics.PIXEL_METER
