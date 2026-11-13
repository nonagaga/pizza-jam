class_name Entity extends CharacterBody2D

static var STACKS_LBL_SETTINGS = preload("res://Effects/Buffbar Stacks.tres")

@export var civil: EntityCivilStats
@export var combat: EntityCombatStats
@export var director: EntityDirectorStats

@onready var live = LiveStats.new()

## This is true when the entity is being forced to move somehow.
## After the forced movement ends (push, pull, dash, etc.), this becomes false.
var is_force_moved = false as bool

var _last_move_vec: Vector2
var _movement_module: MovementModule

var _effects = [] as Array[EntityEffect]

signal added_buff_icon(texture_rect: TextureRect)

func _ready() -> void:
	update_stats()

func _physics_process(delta: float) -> void:
	move_and_slide()

## Creates a [StatRoll] object and passes it through all effects.
## This will update the entity's max health, speed, etc.
func update_stats() -> void:
	var stroll = StatRoll.new()
	modify_stat_roll(stroll)
	_apply_stat_roll(stroll)

func _apply_stat_roll(stroll: StatRoll) -> void:
	live.max_health = stroll.get_final_max_health()
	if live.health > live.max_health:
		live.health = live.max_health
	
	live.walk_speed = stroll.get_final_walk_speed()

func get_movement_module() -> MovementModule:
	return _movement_module

# Effects

func add_effect(new_effect: EntityEffect) -> void:
	if new_effect.stacks_separately:
		_add_new_effect(new_effect)
	elif _find_effect_by_name(new_effect.effect_name) == null:
		_add_new_effect(new_effect)
	else:
		_add_effect_dupes(_find_effect_by_name(new_effect.effect_name), 1)
	
	update_stats()

func remove_effect(owned_effect: EntityEffect) -> void:
	if owned_effect == null:
		return
	
	_effects.erase(owned_effect)
	if owned_effect._buff_icon != null:
		owned_effect._buff_icon.queue_free()
	
	owned_effect.queue_free()
	
	update_stats()

func _find_effect_by_name(eff_name: String) -> EntityEffect:
	for effect in _effects:
		if effect.effect_name == eff_name:
			return effect
	return null

func _add_effect_dupes(owned_effect: EntityEffect, amt: int) -> void:
	owned_effect.add_dupes(amt)

func _add_new_effect(new_effect: EntityEffect) -> void:
	add_child(new_effect)
	_effects.append(new_effect)
	
	if new_effect.is_queued_for_deletion():
		remove_effect(new_effect)
		return
	
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
	update_stats()

# Rolls

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	for effect in _effects:
		effect.modify_ability_roll(abroll)
	
	return abroll

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	stroll.max_health_bonus += combat.max_health
	stroll.walk_speed_bonus += combat.walk_speed
	
	for effect in _effects:
		effect.modify_stat_roll(stroll)
	
	return stroll
