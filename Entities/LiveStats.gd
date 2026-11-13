class_name LiveStats extends Object

var health = 1.0 as float
var max_health = 1.0 as float
var walk_speed = 1.0 as float

func get_pixel_speed() -> float:
	return walk_speed * Physics.PIXEL_METER
