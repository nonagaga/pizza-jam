class_name MovementIO extends MovementController

func _unhandled_key_input(event: InputEvent) -> void:
	var move_norm_vec = Input.get_vector(
		"Move Left", "Move Right", "Move Up", "Move Down")
	movement_module.apply_movement_input(move_norm_vec)
