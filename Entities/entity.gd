class_name Entity extends CharacterBody2D

@export var entity_name = "Unnamed Entity" as String

## This is true when the entity is being forced to move somehow.
## After the forced movement ends (push, pull, dash, etc.), this becomes false.
var is_force_moved = false as bool

func _physics_process(delta: float) -> void:
	move_and_slide()

func get_movement_module() -> MovementModule:
	for child in get_children():
		if child is MovementModule:
			return child
	return null

func codex_dash(direction: Vector2, dash_mult: float,
		dash_duration: float):
	if is_force_moved or direction == Vector2.ZERO:
		return
		
	is_force_moved = true
	
	var normal_speed = get_movement_module().walk_speed * Physics.PIXEL_METER
	var dash_speed = normal_speed * dash_mult
	# Calculate the ratio to hand off perfectly to normal running speed
	var normal_speed_ratio = 1 / dash_mult
	
	var tween = create_tween()
	
	# Pass the lambda function, start value, end value, and duration as clean arguments
	tween.tween_method(
		func(speed_mult: float): 
			velocity = direction.normalized() * dash_speed * speed_mult,
		1.0, 
		normal_speed_ratio, 
		dash_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	is_force_moved = false
