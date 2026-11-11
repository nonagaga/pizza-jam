class_name Ability extends Node

var _ability_slot: AbilitySlot

@export_category("Main")

@export var ability_name = "Unnamed Ability" as String
@export var ability_icon: Texture

@export var ar_modifier: AbilityRollModifier

@export var tag_melee = false as bool

@export_category("Cooldown")

## The cooldown for the button for this ability.
## If the ability has an expected duration, then
## this should be the duration at minimum.
@export var slot_cooldown = 0.1 as float
## The ability that will be swapped to after this ability is used.
@export var combo_ability: Ability
## The timer for which this ability may be used after being swapped to.
@export var combo_timer = 0.0 as float

@export_category("Projectile")

@export var projectile: PackedScene
## If true, then this projectile sticks to the entity that fired it.
## If false, then this projectile moves freely of its owner.
@export var follows_entity = true as bool
## Amount of degrees between each projectile when multishot happens.
@export var multishot_spread = 5.0 as float

@export_category("Effects")

@export var effects: Array[EntityEffect]

func _ready() -> void:
	_ability_slot = get_parent() as AbilitySlot
