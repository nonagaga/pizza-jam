class_name MovementModule extends EntityModule

@export var walk_speed = 8.0 as float

func apply_movement_input(move_vec: Vector2) -> void:
	if entity.is_force_moved:
		return
	entity.velocity = move_vec * walk_speed * Physics.PIXEL_METER
