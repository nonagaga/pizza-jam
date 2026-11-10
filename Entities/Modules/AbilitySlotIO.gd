class_name AbilitySlotIO extends AbilitySlotController

@export var input_action: InputEventAction

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(input_action.action):
		var mouse_pos = ability_slot.entity.get_global_mouse_position()
		ability_slot.use_ability(mouse_pos)
