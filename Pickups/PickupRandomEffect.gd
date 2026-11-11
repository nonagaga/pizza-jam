class_name PickupRandomEffect extends Pickup

@export var random_effects = [] as Array[EntityEffect]
@export var potency = 1 as int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity && body.is_in_group("Player"):
		for i in range(potency):
			body.add_effect(random_effects.pick_random())
		queue_free()
