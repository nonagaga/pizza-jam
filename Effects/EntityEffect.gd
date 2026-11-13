## An effect on the character, such as a slow or a buff.
## If a duplicate effect is added to an entity then it should instead raise
## the "dupe" value of the effect.
class_name EntityEffect extends Node

@onready var _entity = get_parent() as Entity

signal updated_dupes(new_amt: int)
signal updated_dupes_str(new_amt: String)

@export var effect_name = "Unnamed Effect" as String
@export var effect_icon: Texture2D

@export var ability_roll_modifier: AbilityRollModifier
@export var stat_roll_modifier: StatRollModifier

@export var is_permanent = true as bool
@export var stacks_separately = false as bool
@export var lifespan = 0.0 as float

## Maximum amount of dupes this effect can have.
## By default, this is -1, which is infinity.
@export var max_dupes = -1 as int

var _lifespan_timer: Timer

var dupes = 1 as int

# TODO - make this its own UI class
var _buff_icon: TextureRect

func _ready() -> void:
	_start_timer()
	start_effect()

# Timer

func _start_timer() -> void:
	# If timer already exists, restart it.
	# (useful for stacking buffs that reset the timer)
	if _lifespan_timer != null:
		_reset_timer()
		return
	
	# If the effect is not permanent, create a timer.
	if not is_permanent:
		_create_timer()

func _reset_timer() -> void:
	_lifespan_timer.start(lifespan)

func _create_timer() -> void:
	_lifespan_timer = Timer.new()
	_lifespan_timer.timeout.connect(_timeout)
	add_child(_lifespan_timer)
	_lifespan_timer.start(lifespan)

func _timeout() -> void:
	end_effect()
	_entity.remove_effect(self)

# Rolls

func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	if ability_roll_modifier == null:
		return
	
	for i in range(dupes):
		ability_roll_modifier.modify_ability_roll(abroll)
	return abroll

func modify_stat_roll(stroll: StatRoll) -> StatRoll:
	if stat_roll_modifier == null:
		return
	
	for i in range(dupes):
		stat_roll_modifier.modify_stat_roll(stroll)
	return stroll

# Effects

func start_effect() -> void:
	pass

func end_effect() -> void:
	pass

func periodic_effect() -> void:
	pass

# -

func add_dupes(amt: int) -> void:
	dupes += amt
	if max_dupes > -1 && dupes > max_dupes:
		dupes = max_dupes
	_start_timer()
	update_icon()

func update_icon() -> void:
	updated_dupes.emit(dupes)
	updated_dupes_str.emit(str(dupes))
