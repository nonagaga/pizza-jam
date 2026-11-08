
class_name AbilityModule extends EntityModule

static var LEFT_SWING = preload("res://Abilities/Left Swing/LeftSwing.tres") as Ability

@export var primary_ability: Ability

signal changed_primary_icon(texture: Texture2D)

var secondary_ability

func _ready() -> void:
	swap_primary_ability(primary_ability)


func swap_primary_ability(new_ability: Ability) -> void:
	primary_ability = new_ability
	changed_primary_icon.emit(new_ability.ability_icon)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Primary Ability"):
		use_primary_ability()

func use_primary_ability() -> void:
	var proj = primary_ability.projectile.instantiate() as AbilityProjectile
	
	entity.add_child(proj)
	
	if primary_ability.combo_ability == null:
		swap_primary_ability(LEFT_SWING)
	else:
		swap_primary_ability(primary_ability.combo_ability)
