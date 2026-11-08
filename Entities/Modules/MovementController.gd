@abstract @tool
class_name MovementController extends Node

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not MovementModule:
		return ["Parent must be an EntityMovement node."]
	else:
		return []


@onready var entity_movement = get_parent() as MovementModule
