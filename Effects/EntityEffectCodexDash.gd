class_name EntityEffectCodexDash extends EntityEffect

func in_apply(entity: Entity) -> void:
	if entity._last_move_vec == Vector2.ZERO:
		entity.delete_effect_holder_by_effect(self)
		return
	codex_dash(entity, entity._last_move_vec, 4.0, 0.4)

func codex_dash(entity: Entity, direction: Vector2, dash_mult: float,
		dash_duration: float):
	if entity.is_force_moved or direction == Vector2.ZERO:
		entity.delete_effect_holder_by_effect(self)
		return
		
	entity.is_force_moved = true
	
	var normal_speed = entity.live.get_pixel_speed()
	var dash_speed = normal_speed * dash_mult
	# Calculate the ratio to hand off perfectly to normal running speed
	var normal_speed_ratio = 1 / dash_mult
	
	var tween = entity.create_tween()
	
	# Pass the lambda function, start value, end value, and duration as clean arguments
	tween.tween_method(
		func(speed_mult: float): 
			entity.velocity = direction.normalized() * dash_speed * speed_mult,
		1.0, 
		normal_speed_ratio, 
		dash_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	entity.is_force_moved = false
	entity.delete_effect_holder_by_effect(self)
