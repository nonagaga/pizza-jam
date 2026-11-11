class_name EntityEffectHolder extends Node

signal updated_dupes(new_amt: int)
signal updated_dupes_str(new_amt: String)

var effect: EntityEffect

@onready var _entity := get_parent() as Entity
var _lifespan_timer: Timer
# TODO - make this its own UI class
var _buff_icon: TextureRect

var dupes = 1 as int

func _ready() -> void:
	_start_timer()
	effect.in_apply(_entity)

# Timer

func _start_timer() -> void:
	# If timer already exists, restart it.
	# (useful for stacking buffs that reset the timer)
	if _lifespan_timer != null:
		_reset_timer()
		return
	
	# If the effect is not permanent, create a timer.
	if not effect.is_permanent:
		_create_timer()

func _reset_timer() -> void:
	_lifespan_timer.start(effect.lifespan)

func _create_timer() -> void:
	_lifespan_timer = Timer.new()
	_lifespan_timer.timeout.connect(_timeout)
	add_child(_lifespan_timer)
	_lifespan_timer.start(effect.lifespan)

func _timeout() -> void:
	effect.out_apply(_entity)
	_entity.delete_effect_holder(self)

# Rolls

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	if effect.ability_roll_modifier == null:
		return
	
	# HACK - This could be more efficient
	for i in range(dupes):
		effect.ability_roll_modifier.modify_ability_roll(abroll)
	return abroll

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	if effect.stat_roll_modifier == null:
		return
	
	for i in range(dupes):
		effect.stat_roll_modifier.modify_stat_roll(stroll)
	return stroll

# -

func add_dupes(amt: int) -> void:
	dupes += amt
	if effect.max_dupes > -1 && dupes > effect.max_dupes:
		dupes = effect.max_dupes
	_start_timer()
	update_icon()

func update_icon() -> void:
	updated_dupes.emit(dupes)
	updated_dupes_str.emit(str(dupes))
