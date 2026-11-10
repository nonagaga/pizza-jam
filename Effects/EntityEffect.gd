## An effect on the character, such as a slow or a buff.
## If a duplicate effect is added to an entity then it should instead raise
## the "dupe" value of the effect.
class_name EntityEffect extends Node

@onready var _entity = get_parent() as Entity

@export var effect_name = "Unnamed Effect" as String

@export var ability_roll_modifier: AbilityRollModifier

@export var is_permanent = true as bool
@export var stacks_separately = false as bool
@export var lifetime = 0.0 as float

var dupes = 1 as int

func _ready() -> void:
	if is_permanent:
		set_process(false)

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		_entity.remove_effect(self)
