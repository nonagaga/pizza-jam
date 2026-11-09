## Something that can be spawned by an ability instead of a projectile.
## Could be an effect on the entity (dash) or a buff.
class_name EntityEffect extends Node2D

@onready var entity = get_parent() as Entity

func do_effect() -> void:
	pass
