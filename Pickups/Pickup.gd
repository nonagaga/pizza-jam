class_name Pickup extends Node2D

@export var permanent_buff: PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity && body.is_in_group("Player"):
		body.add_effect(permanent_buff.instantiate())
		queue_free()
