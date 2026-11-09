## An effect on the character, such as a slow or a buff.
## If a duplicate effect is added to an entity then it should instead raise
## the "dupe" value of the effect.
class_name EntityEffect extends Node2D

@onready var entity = get_parent() as Entity

var dupe = 1 as int

func do_effect() -> void:
	pass
