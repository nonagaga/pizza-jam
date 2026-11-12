
class_name MovementAI extends MovementController

@export var follow_distance = 30.0 as float

func _process(_delta: float) -> void:
	_move_to_focus()

func _move_to_focus() -> void:
	var focus_entity = _find_closest_enemy()
	if focus_entity == null:
		return
	
	var focus_meters = movement_module.entity.global_position.distance_to(
		focus_entity.global_position) / Physics.PIXEL_METER
	
	if focus_meters > follow_distance:
		movement_module.apply_movement_input(Vector2.ZERO)
		return
		
	var move_norm_vec = (focus_entity.global_position - 
		movement_module.entity.global_position).normalized()
	
	movement_module.apply_movement_input(move_norm_vec)

func _find_closest_enemy() -> Entity:
	var this_entity = movement_module.entity
	var closest: Entity = null
	for e: Entity in get_tree().get_nodes_in_group("Entity"):
		if e.director.team == this_entity.director.team:
			continue
		if closest == null:
			closest = e
			continue
		if this_entity.global_position.distance_to(e.global_position) < this_entity.global_position.distance_to(closest.global_position):
			closest = e
	
	return closest
