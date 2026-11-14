class_name LiveStats extends Object

var _entity: Entity

var health = 1.0 as float
var max_health = 1.0 as float
var walk_speed = 1.0 as float

func get_pixel_speed() -> float:
	return walk_speed * Physics.PIXEL_METER

func deal_damage(amt: float, from: Entity = null) -> void:
	health -= amt
	if health <= 0.0:
		_entity.die.call_deferred()

func heal(amt: float) -> void:
	health += amt
	if health >= max_health:
		health = max_health
