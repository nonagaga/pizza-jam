@tool
class_name SkirmishManager extends Node2D

func _get_configuration_warnings() -> PackedStringArray:
	if get_child_count() == 0:
		return ["This node should have at least 1 EntitySpawner node in it."]
	
	for child in get_children():
		if child is not EntitySpawner:
			return ["This node should only have EntitySpawner children."]
	
	return []
