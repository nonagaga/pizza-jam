## An effect on the character, such as a slow or a buff.
## If a duplicate effect is added to an entity then it should instead raise
## the "dupe" value of the effect.
class_name EntityEffect extends Resource

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

func in_apply(entity: Entity) -> void:
	pass

func out_apply(entity: Entity) -> void:
	pass

func periodic_apply(entity: Entity) -> void:
	pass
