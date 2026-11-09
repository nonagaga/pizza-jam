@tool
class_name MovementInput extends MovementController


func _unhandled_key_input(event: InputEvent) -> void:
	var move_norm_vec = Input.get_vector(
		"Move Left", "Move Right", "Move Up", "Move Down")
	entity_movement.apply_movement_input(move_norm_vec)
