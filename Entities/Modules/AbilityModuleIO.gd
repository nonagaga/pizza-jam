class_name AbilityModuleIO extends AbilityModuleController

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = ability_module.entity.get_global_mouse_position()
	if event.is_action_pressed("Primary Ability"):
		if ability_module._slot_timer_primary > 0.0:
			return
		ability_module.use_primary_ability(mouse_pos)
	
	elif event.is_action_pressed("Secondary Ability"):
		if ability_module._slot_timer_secondary > 0.0:
			return
		ability_module.use_secondary_ability(mouse_pos)
	
	elif event.is_action_pressed("Dash"):
		if ability_module._slot_timer_dash > 0.0:
			return
		ability_module.use_dash_ability(mouse_pos)
