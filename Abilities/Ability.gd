class_name Ability extends Resource

@export var ability_name = "Unnamed Ability" as String
@export var ability_icon: Texture

@export var projectile: PackedScene

## The cooldown for the button for this ability.
## If the ability has an expected duration, then
## this should be the duration at minimum.
@export var slot_cooldown = 0.1 as float

@export var combo_ability: Ability
@export var combo_timer = 0.0 as float
