
class_name MovementAI extends MovementController

@export var follow_distance = 30.0 as float

var _player: Entity

func _process(delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("Player")
	
	var focus_meters = movement_module.entity.global_position.distance_to(
		_player.global_position) / Physics.PIXEL_METER
	
	if focus_meters > follow_distance:
		movement_module.apply_movement_input(Vector2.ZERO)
		return
	
	var move_norm_vec = (_player.global_position - 
		movement_module.entity.global_position).normalized()
	
	movement_module.apply_movement_input(move_norm_vec)
