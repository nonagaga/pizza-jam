class_name AbilitySlot extends EntityModule

@export var default_ability: Ability
var ability: Ability

var _combo_countdown = 0.0 as float
var _slot_countdown = 0.0 as float

signal swapped_ability(next_ability: Ability)
signal swapped_ability_icon(next_icon: Texture2D)

func _ready() -> void:
	ability = default_ability

func _process(delta: float) -> void:
	_countdown_combo_timer(delta)
	_countdown_slot_timer(delta)

func _countdown_combo_timer(delta: float) -> void:
	if _combo_countdown > 0.0:
		_combo_countdown -= delta
		if _combo_countdown <= 0.0:
			swap_ability(default_ability)

func _countdown_slot_timer(delta: float) -> void:
	if _slot_countdown > 0.0:
		_slot_countdown -= delta

func can_use_ability() -> bool:
	if _slot_countdown > 0:
		return false
	if ability == null:
		return false
	return true

func swap_ability(next_ability: Ability) -> void:
	ability = next_ability
	swapped_ability.emit(next_ability)
	swapped_ability_icon.emit(next_ability.ability_icon)

func use_ability(target_pos: Vector2) -> void:
	if !can_use_ability():
		return
	
	var abroll = ability.ar_modifier.generate_ability_roll()
	entity.modify_ability_roll(abroll)
	
	var ms = abroll.get_final_multishot()
	
	if ability.projectile != null:
		if ability.tag_melee:
			var sep_deg = ability.multishot_spread / ms
			for i in range(ms):
				_spawn_projectile(target_pos, abroll, sep_deg * i) 
		else:
			_spawn_projectile(target_pos, abroll)
	
	if ability.effects != null:
		for effect in ability.effects:
			entity.add_effect(effect.instantiate())
	
	if ability.combo_ability == null:
		swap_ability(default_ability)
	else:
		swap_ability(ability.combo_ability)
		_combo_countdown = ability.combo_timer
	
	_slot_countdown = ability.slot_cooldown

func _spawn_projectile(target_pos: Vector2, abroll: AbilityRoll,
		additional_rotation_deg: float = 0.0) -> void:
	var proj = ability.projectile.instantiate() as AbilityProjectile
	proj.aim_rotation = rad_to_deg(entity.global_position.angle_to_point(target_pos)
		) + additional_rotation_deg
	proj.scale *= abroll.get_final_range()
	
	if ability.follows_entity:
		entity.add_child(proj)
	else:
		# HACK - Spawns the projectile without a Node2D parent so it technically is free of the player's position.
		add_child(proj)
