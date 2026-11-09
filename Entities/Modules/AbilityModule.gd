@tool
class_name AbilityModule extends EntityModule

static var LEFT_SWING = preload("res://Abilities/Left Swing/LeftSwing.tres") as Ability
static var DASH = preload("res://Abilities/Dash/Dash.tres") as Ability

@export var primary_ability: Ability
@export var secondary_ability: Ability

var _slot_timer_primary = 0.0 as float
var _combo_timer_primary = 0.0 as float
var _slot_timer_secondary = 0.0 as float
var _combo_timer_secondary = 0.0 as float

## Ability modifiers as percentages.
## Gained from rougelike items, can upgrade each ability.
@export var ability_range_mod = 0.0 as float
@export var ability_duration_mod = 0.0 as float
@export var ability_strength_mod = 0.0 as float
@export var ability_cooldown_mod = 0.0 as float

signal changed_primary_icon(texture: Texture2D)
signal changed_secondary_icon(texture: Texture2D)



func _ready() -> void:
	swap_primary_ability(primary_ability)

func _process(delta: float) -> void:
	if _slot_timer_primary >= 0.0:
		_slot_timer_primary -= delta
	if _combo_timer_primary >= 0.0:
		_combo_timer_primary -= delta
		if _combo_timer_primary <= 0.0:
			swap_primary_ability(LEFT_SWING)
	
	if _slot_timer_secondary >= 0.0:
		_slot_timer_secondary -= delta
	if _combo_timer_secondary >= 0.0:
		_combo_timer_secondary -= delta
		if _combo_timer_secondary <= 0.0:
			swap_secondary_ability(DASH)

func swap_primary_ability(new_ability: Ability) -> void:
	primary_ability = new_ability
	changed_primary_icon.emit(new_ability.ability_icon)

func swap_secondary_ability(new_ability: Ability) -> void:
	secondary_ability = new_ability
	changed_secondary_icon.emit(new_ability.ability_icon)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Primary Ability"):
		if _slot_timer_primary > 0.0:
			return
		use_primary_ability()
	
	elif event.is_action_pressed("Secondary Ability"):
		if _slot_timer_secondary > 0.0:
			return
		use_secondary_ability()

func use_primary_ability() -> void:
	_slot_timer_primary = primary_ability.slot_cooldown
	
	if primary_ability.projectile != null:
		var proj = primary_ability.projectile.instantiate() as AbilityProjectile
		entity.add_child(proj)
	
	if primary_ability.combo_ability == null:
		swap_primary_ability(LEFT_SWING)
	else:
		swap_primary_ability(primary_ability.combo_ability)
		_combo_timer_primary = primary_ability.combo_timer


func use_secondary_ability() -> void:
	_slot_timer_secondary = secondary_ability.slot_cooldown
	
	if secondary_ability.projectile != null:
		var proj = secondary_ability.projectile.instantiate() as AbilityProjectile
		entity.add_child(proj)
	if secondary_ability.effect != null:
		var eff = secondary_ability.effect.instantiate() as EntityEffect
		entity.add_child(eff)
		eff.do_effect()
	
	if secondary_ability.combo_ability == null:
		swap_secondary_ability(DASH)
	else:
		swap_secondary_ability(secondary_ability.combo_ability)
		_combo_timer_secondary = secondary_ability.combo_timer
