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

@export var is_permanent = true as bool
@export var stacks_separately = false as bool
@export var lifetime = 0.0 as float

var dupes = 1 as int

var _buff_icon: TextureRect

func _ready() -> void:
	if is_permanent:
		set_process(false)
	start_effect()

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		end_effect()
		_entity.remove_effect(self)

func start_effect() -> void:
	pass

func end_effect() -> void:
	pass

func add_dupes(amt: int) -> void:
	dupes += amt
	update_icon()

func update_icon() -> void:
	updated_dupes.emit(dupes)
	updated_dupes_str.emit(str(dupes))
