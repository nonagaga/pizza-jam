## Automatically uses abilities at certain ranges and conditions
class_name AbilityModuleAI extends AbilityModuleController

@export var distance_for_abil1 = 5.0 as float
@export var distance_for_abil2 = 10.0 as float

var _player: Entity

func _process(delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("Player")
	
	var focus_meters = ability_module.entity.global_position.distance_to(
		_player.global_position) / Physics.PIXEL_METER
	
	if focus_meters <= distance_for_abil1 && ability_module._slot_timer_primary <= 0.0:
		ability_module.use_primary_ability()
	elif focus_meters <= distance_for_abil2 && ability_module._slot_timer_secondary <= 0.0:
		ability_module.use_secondary_ability()
