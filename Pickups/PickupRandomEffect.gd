class_name PickupRandomEffect extends Pickup

@export var random_effects = [] as Array[PackedScene]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity && body.is_in_group("Player"):
		body.add_effect(random_effects.pick_random().instantiate())
		queue_free()
