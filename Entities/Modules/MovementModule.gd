@tool
class_name MovementModule extends EntityModule

@onready var entity = get_parent() as Entity

@export var walk_speed = 8.0 as float

func _get_configuration_warnings() -> PackedStringArray:
	var has_module = false
	for child in get_children():
		if child is MovementController:
			has_module = true
			break
	if not has_module:
		return ["Must have a MovementAI or MovementInput module."]
	else:
		return []

func apply_movement_input(move_vec: Vector2) -> void:
	entity.velocity = move_vec * walk_speed * Physics.PIXEL_METER
