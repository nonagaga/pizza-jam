class_name Entity extends CharacterBody2D

static var STACKS_LBL_SETTINGS = preload("res://Effects/Buffbar Stacks.tres")

@export var civil: EntityCivilStats
@export var combat: EntityCombatStats
@export var director: EntityDirectorStats
@export var drop_tables: Array[EntityDropTable]

@onready var live := LiveStats.new()

## This is true when the entity is being forced to move somehow.
## After the forced movement ends (push, pull, dash, etc.), this becomes false.
var is_force_moved = false as bool

var _last_move_vec: Vector2
var _movement_module: MovementModule

var _effect_holders := [] as Array[EntityEffectHolder]

signal added_buff_icon(texture_rect: TextureRect)

func _ready() -> void:
	live._entity = self
	set_navigation_map()
	update_stats()
	full_heal()

func _physics_process(delta: float) -> void:
	move_and_slide()

# TODO - For Gabe
func set_navigation_map() -> void:
	pass

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

func full_heal() -> void:
	live.health = live.max_health

# Effects

func add_effect(new_effect: EntityEffect, dupes: int = 1) -> void:
	if new_effect.stacks_separately:
		_add_new_effect_holder(new_effect).add_dupes(dupes-1)
	elif _find_effect_holder_by_name(new_effect.effect_name) == null:
		_add_new_effect_holder(new_effect).add_dupes(dupes-1)
	else:
		_add_effect_dupes(
			_find_effect_holder_by_name(new_effect.effect_name), dupes)
	
	update_stats()

func delete_effect_holder_by_effect(effect: EntityEffect) -> void:
	for eh in _effect_holders:
		if eh.effect == effect:
			delete_effect_holder(eh)

func delete_effect_holder(owned_eh: EntityEffectHolder) -> void:
	if owned_eh == null:
		return
	
	_effect_holders.erase(owned_eh)
	if owned_eh._buff_icon != null:
		owned_eh._buff_icon.queue_free()
	
	owned_eh.queue_free()
	
	update_stats()

func _find_effect_holder_by_name(eff_name: String) -> EntityEffectHolder:
	for eh in _effect_holders:
		if eh.effect.effect_name == eff_name:
			return eh
	return null

func _add_effect_dupes(owned_eh: EntityEffectHolder, amt: int) -> void:
	owned_eh.add_dupes(amt)

func _add_new_effect_holder(new_effect: EntityEffect) -> EntityEffectHolder:
	var new_eh = EntityEffectHolder.new()
	new_eh.effect = new_effect
	add_child(new_eh)
	_effect_holders.append(new_eh)
	
	if new_effect.is_queued_for_deletion():
		delete_effect_holder(new_eh)
		return
	
	var trect = TextureRect.new()
	new_eh._buff_icon = trect
	trect.texture = new_effect.effect_icon
	trect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	added_buff_icon.emit(trect)
	
	var lbl = Label.new()
	lbl.text = str(new_eh.dupes)
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.label_settings = STACKS_LBL_SETTINGS
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	new_eh.updated_dupes_str.connect(lbl.set_text)
	trect.add_child(lbl)
	
	new_eh.update_icon()
	update_stats()
	return new_eh

# Rolls

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	for eh in _effect_holders:
		eh.modify_ability_roll(abroll)
	
	return abroll

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	stroll.max_health_bonus += combat.max_health
	stroll.walk_speed_bonus += combat.walk_speed
	
	for eh in _effect_holders:
		eh.modify_stat_roll(stroll)
	
	return stroll

# Damage, Death

func die() -> void:
	var root = get_tree().root
	
	for dt in drop_tables:
		var pickups = dt.roll_pickups()
		for p in pickups:
			_drop_pickup(p)
	
	queue_free()

func _drop_pickup(pickup: PackedScene) -> void:
	var nearby_vec = Vector2(randf(), randf()) * Physics.PIXEL_METER * 1.0
	var pickup_node = pickup.instantiate() as Pickup
	pickup_node.global_position = global_position + nearby_vec
	get_tree().root.add_child(pickup_node)

func _on_hitbox_body_entered(body: Node2D) -> void:
	
	if body is AbilityProjectile:
		if body.originator.director.team == director.team:
			return
		
		live.deal_damage(body.ability_roll.get_final_damage(), body.originator)
		
		for effect in body.ability_roll.on_hit_effects:
			add_effect(effect)
	
	pass # Replace with function body.

# Saving

## Saving data that carries between levels and deaths.
func save_carryover_data() -> void:
	Director.save_carryover_data(self)
