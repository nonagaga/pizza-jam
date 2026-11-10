class_name Entity extends CharacterBody2D

@export var civil: EntityCivilStats
@export var combat: EntityCombatStats
@export var director: EntityDirectorStats

## This is true when the entity is being forced to move somehow.
## After the forced movement ends (push, pull, dash, etc.), this becomes false.
var is_force_moved = false as bool

var _movement_module: MovementModule

var _effects = [] as Array[EntityEffect]

func _physics_process(delta: float) -> void:
	move_and_slide()

func get_movement_module() -> MovementModule:
	return _movement_module

func add_effect(new_effect: EntityEffect) -> void:
	if new_effect.stacks_separately:
		add_child(new_effect)
		_effects.append(new_effect)
		return
	
	for effect in _effects:
		if new_effect.effect_name == effect.effect_name:
			effect.dupes += 1
			return
	# else...
	add_child(new_effect)
	_effects.append(new_effect)

func remove_effect(owned_effect: EntityEffect) -> void:
	_effects.erase(owned_effect)
	owned_effect.queue_free()

func diminish_effect(owned_effect: EntityEffect, amt: int) -> void:
	owned_effect.dupes -= amt

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	for effect in _effects:
		for i in range(effect.dupes):
			effect.ability_roll_modifier.modify_ability_roll(abroll)
	
	return abroll

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
