class_name Entity extends CharacterBody2D

static var STACKS_LBL_SETTINGS = preload("res://Effects/Buffbar Stacks.tres")

@export var civil: EntityCivilStats
@export var combat: EntityCombatStats
@export var director: EntityDirectorStats

## This is true when the entity is being forced to move somehow.
## After the forced movement ends (push, pull, dash, etc.), this becomes false.
var is_force_moved = false as bool

var _last_move_vec: Vector2
var _movement_module: MovementModule

var _effects = [] as Array[EntityEffect]

signal added_buff_icon(texture_rect: TextureRect)

func _physics_process(delta: float) -> void:
	move_and_slide()

## Creates a [StatRoll] object and passes it through all effects.
## This will update the entity's max health, speed, etc.
func make_stat_roll() -> void:
	pass

func get_movement_module() -> MovementModule:
	return _movement_module

func add_effect(new_effect: EntityEffect) -> void:
	if new_effect.stacks_separately:
		_add_new_effect(new_effect)
		return
	
	for effect in _effects:
		if new_effect.effect_name == effect.effect_name:
			effect.add_dupes(1)
			return
	# else...
	_add_new_effect(new_effect)

func remove_effect(owned_effect: EntityEffect) -> void:
	if owned_effect == null:
		return
	_effects.erase(owned_effect)
	if owned_effect._buff_icon != null:
		owned_effect._buff_icon.queue_free()
	owned_effect.queue_free()

func diminish_effect(owned_effect: EntityEffect, amt: int) -> void:
	owned_effect.add_dupes(-amt)

func _add_new_effect(new_effect: EntityEffect) -> void:
	add_child(new_effect)
	_effects.append(new_effect)
	
	var trect = TextureRect.new()
	new_effect._buff_icon = trect
	trect.texture = new_effect.effect_icon
	trect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	added_buff_icon.emit(trect)
	
	var lbl = Label.new()
	lbl.text = str(new_effect.dupes)
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.label_settings = STACKS_LBL_SETTINGS
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	new_effect.updated_dupes_str.connect(lbl.set_text)
	trect.add_child(lbl)
	
	new_effect.update_icon()

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	for effect in _effects:
		effect.modify_ability_roll(abroll)
	
	return abroll

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	for effect in _effects:
		effect.modify_stat_roll(stroll)
	
	return stroll
