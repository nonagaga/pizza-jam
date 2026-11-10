extends CharacterBody2D


@export var speed: float =150.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.4


var is_dashing: bool = false


func start_dash(direction: Vector2):
	if is_dashing or direction == Vector2.ZERO:
		return
		
	is_dashing = true
	
	
	# Calculate the ratio to hand off perfectly to normal running speed
	var normal_speed_ratio = speed / dash_speed
	
	var tween = create_tween()
	
	# Pass the lambda function, start value, end value, and duration as clean arguments
	tween.tween_method(
		func(speed_mult: float): 
			velocity = direction.normalized() * (dash_speed * speed_mult),
		1.0, 
		normal_speed_ratio, 
		dash_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	is_dashing = false
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right","ui_up", "ui_down")
	if not is_dashing:
		velocity = direction * speed
	
	if Input.is_action_pressed("ui_select") and not is_dashing:
		start_dash(direction)
	

	move_and_slide()
