extends EntityEffect

func start_effect() -> void:
	codex_dash(_entity._last_move_vec, 4.0, 0.4)
	#_entity.remove_effect(self)

func codex_dash(direction: Vector2, dash_mult: float,
		dash_duration: float):
	if _entity.is_force_moved or direction == Vector2.ZERO:
		return
		
	_entity.is_force_moved = true
	
	var normal_speed = _entity.combat.get_walk_speed()
	var dash_speed = normal_speed * dash_mult
	# Calculate the ratio to hand off perfectly to normal running speed
	var normal_speed_ratio = 1 / dash_mult
	
	print(normal_speed, dash_speed, normal_speed_ratio)
	
	var tween = create_tween()
	
	# Pass the lambda function, start value, end value, and duration as clean arguments
	tween.tween_method(
		func(speed_mult: float): 
			_entity.velocity = direction.normalized() * dash_speed * speed_mult,
		1.0, 
		normal_speed_ratio, 
		dash_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	_entity.is_force_moved = false
	_entity.remove_effect(self)
