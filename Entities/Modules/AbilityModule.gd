class_name AbilityModule extends EntityModule

@export var default_primary_ability: Ability
@export var default_secondary_ability: Ability
@export var default_dash_ability: Ability

var primary_ability: Ability
var secondary_ability: Ability
var dash_ability: Ability

var _slot_timer_primary = 0.0 as float
var _combo_timer_primary = 0.0 as float
var _slot_timer_secondary = 0.0 as float
var _combo_timer_secondary = 0.0 as float
var _slot_timer_dash = 0.0 as float
var _combo_timer_dash = 0.0 as float


## Ability modifiers as percentages.
## Gained from rougelike items, can upgrade each ability.
@export var ability_range_mod = 0.0 as float
@export var ability_duration_mod = 0.0 as float
@export var ability_strength_mod = 0.0 as float
@export var ability_cooldown_mod = 0.0 as float

signal changed_primary_icon(texture: Texture2D)
signal changed_secondary_icon(texture: Texture2D)



func _ready() -> void:
	primary_ability = default_primary_ability
	secondary_ability = default_secondary_ability
	dash_ability = default_dash_ability
	swap_primary_ability(primary_ability)
	swap_secondary_ability(secondary_ability)
	swap_dash_ability(dash_ability)

func _process(delta: float) -> void:
	if _slot_timer_primary >= 0.0:
		_slot_timer_primary -= delta
	if _combo_timer_primary >= 0.0:
		_combo_timer_primary -= delta
		if _combo_timer_primary <= 0.0:
			swap_primary_ability(default_primary_ability)
	
	if _slot_timer_secondary >= 0.0:
		_slot_timer_secondary -= delta
	if _combo_timer_secondary >= 0.0:
		_combo_timer_secondary -= delta
		if _combo_timer_secondary <= 0.0:
			swap_secondary_ability(default_secondary_ability)
	
	if _slot_timer_dash >= 0.0:
		_slot_timer_dash -= delta
	if _combo_timer_dash >= 0.0:
		_combo_timer_dash -= delta
		if _combo_timer_dash <= 0.0:
			swap_dash_ability(default_dash_ability)

func swap_primary_ability(new_ability: Ability) -> void:
	primary_ability = new_ability
	if new_ability == null:
		return
	changed_primary_icon.emit(new_ability.ability_icon)

func swap_secondary_ability(new_ability: Ability) -> void:
	secondary_ability = new_ability
	if new_ability == null:
		return
	changed_secondary_icon.emit(new_ability.ability_icon)

func swap_dash_ability(new_ability: Ability) -> void:
	dash_ability = new_ability
	if new_ability == null:
		return

func use_primary_ability(direction: Vector2) -> void:
	if primary_ability == null:
		return
	
	_slot_timer_primary = primary_ability.slot_cooldown
	
	if primary_ability.projectile != null:
		var proj = primary_ability.projectile.instantiate() as AbilityProjectile
		proj.set_aim_rotation(direction)
		entity.add_child(proj)
	
	if primary_ability.combo_ability == null:
		swap_primary_ability(default_primary_ability)
	else:
		swap_primary_ability(primary_ability.combo_ability)
		_combo_timer_primary = primary_ability.combo_timer


func use_secondary_ability(direction: Vector2) -> void:
	if secondary_ability == null:
		return
	
	_slot_timer_secondary = secondary_ability.slot_cooldown
	
	if secondary_ability.projectile != null:
		var proj = secondary_ability.projectile.instantiate() as AbilityProjectile
		proj.set_aim_rotation(direction)
		entity.add_child(proj)
	if secondary_ability.effect != null:
		var eff = secondary_ability.effect.instantiate() as EntityEffect
		eff.set_aim_rotation(direction)
		entity.add_child(eff)
		eff.do_effect()
	
	if secondary_ability.combo_ability == null:
		swap_secondary_ability(default_secondary_ability)
	else:
		swap_secondary_ability(secondary_ability.combo_ability)
		_combo_timer_secondary = secondary_ability.combo_timer

func use_dash_ability(direction: Vector2) -> void:
	if dash_ability == null:
		return
	
	_slot_timer_dash = dash_ability.slot_cooldown
	
	if dash_ability.projectile != null:
		var proj = dash_ability.projectile.instantiate() as AbilityProjectile
		proj.set_aim_rotation(direction)
		entity.add_child(proj)
	if dash_ability.effect != null:
		var eff = dash_ability.effect.instantiate() as EntityEffect
		eff.set_aim_rotation(direction)
		entity.add_child(eff)
		eff.do_effect()
	
	if dash_ability.combo_ability == null:
		swap_dash_ability(default_dash_ability)
	else:
		swap_dash_ability(dash_ability.combo_ability)
		_combo_timer_dash = dash_ability.combo_timer
