class_name MovementIO extends MovementController

var _move_norm_vec = Vector2.ZERO

# This should be in _process instead of _input because of keyboard-related godot bugs.
func _process(_delta: float) -> void:
	_move_norm_vec = Input.get_vector(
		"Move Left", "Move Right", "Move Up", "Move Down")
	movement_module.apply_movement_input(_move_norm_vec)
