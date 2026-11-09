@tool
class_name AbilityModule extends EntityModule

static var LEFT_SWING = preload("res://Abilities/Left Swing/LeftSwing.tres") as Ability

@export var primary_ability: Ability
@export var secondary_ability: Ability

## Ability modifiers as percentages.
## Gained from rougelike items, can upgrade each ability.
@export var ability_range_mod = 0.0 as float
@export var ability_duration_mod = 0.0 as float
@export var ability_strength_mod = 0.0 as float
@export var ability_cooldown_mod = 0.0 as float



signal changed_primary_icon(texture: Texture2D)


var _slot_timer_primary = 0.0 as float
var _combo_timer_primary = 0.0 as float

func _ready() -> void:
	swap_primary_ability(primary_ability)

func _process(delta: float) -> void:
	if _slot_timer_primary >= 0.0:
		_slot_timer_primary -= delta
	if _combo_timer_primary >= 0.0:
		_combo_timer_primary -= delta
		if _combo_timer_primary <= 0.0:
			swap_primary_ability(LEFT_SWING)

func swap_primary_ability(new_ability: Ability) -> void:
	primary_ability = new_ability
	changed_primary_icon.emit(new_ability.ability_icon)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Primary Ability"):
		if _slot_timer_primary > 0.0:
			return
		use_primary_ability()

func use_primary_ability() -> void:
	_slot_timer_primary = primary_ability.slot_cooldown
	var proj = primary_ability.projectile.instantiate() as AbilityProjectile
	
	entity.add_child(proj)
	
	if primary_ability.combo_ability == null:
		swap_primary_ability(LEFT_SWING)
	else:
		swap_primary_ability(primary_ability.combo_ability)
		_combo_timer_primary = primary_ability.combo_timer
