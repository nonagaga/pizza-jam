extends EntityEffect

func do_effect() -> void:
	entity.codex_dash((get_global_mouse_position() - global_position),
		4.0, 0.5)
	queue_free()
