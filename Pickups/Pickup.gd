class_name Pickup extends Node2D

@export var entity_effect: AbilityEffect

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var effect_manager: AbilityEffectManager = \
		body.get_node_or_null("AbilityEffectManager")
		
		if effect_manager == null:
			return
		
		effect_manager.add_effect(entity_effect)
		queue_free()
