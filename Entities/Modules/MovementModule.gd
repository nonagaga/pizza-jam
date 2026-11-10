class_name MovementModule extends EntityModule

func _ready() -> void:
	entity._movement_module = self

func apply_movement_input(move_vec: Vector2) -> void:
	if entity.is_force_moved:
		return
	entity.velocity = move_vec * entity.combat.get_walk_speed()
