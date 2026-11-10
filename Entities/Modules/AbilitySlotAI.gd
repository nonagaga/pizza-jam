## Automatically uses abilities at certain ranges and conditions
class_name AbilitySlotAI extends AbilitySlotController

@export var target_distance_min = 0.0 as float
@export var target_distance_max = 5.0 as float

var _player: Entity

func _process(delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("Player")
	
	var target_meters = ability_slot.entity.global_position.distance_to(
		_player.global_position) / Physics.PIXEL_METER
	
	if target_distance_min <= target_meters && target_meters <= target_distance_max:
		ability_slot.use_ability(_player.global_position)
