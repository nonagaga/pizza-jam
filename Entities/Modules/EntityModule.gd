@abstract @tool
class_name EntityModule extends Node

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is not Entity:
		return ["Parent should be an Entity."]
	else:
		return []

@onready var entity = get_parent() as Entity
