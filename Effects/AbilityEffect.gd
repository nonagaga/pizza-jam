## An effect on the character, such as a slow or a buff.
## If a duplicate effect is added to an entity then it should instead raise
## the "dupe" value of the effect.
class_name AbilityEffect extends Resource

@export var effect_name = "Unnamed Effect" as String

@export var ability_roll_modifier: AbilityRollModifier

@export var is_permanent = true as bool
@export var stacks_separately = false as bool
@export var lifetime = 0.0 as float

var remaining_time = 0.0 as float
var dupes = 1 as int

func initialize() -> void:
	remaining_time = lifetime

## Override this function to create an on apply effects to the ability. This
## could be something along the line of a knockback, or an instantaneous damage
## effect
func on_apply(target: Node) -> void:
	pass
	#ability_roll_modifier.modify_ability_roll()
	
## Override this function to create an on tick effect to the ability. This
## could be something along the lines of a burn effect, or any damage over time
## effect
func on_tick(target: Node, delta: float) -> void:
	pass

## Override this function to create an on remove effect to the ability. This can
## could be something along the lines of a post mortem execute or debuff, or just
## a function for effect clean up.
func on_remove(target: Node) -> void:
	pass
