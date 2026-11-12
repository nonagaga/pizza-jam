class_name AbilityEffectManager
extends Node

@export var active_effects: Array[AbilityEffect] = []

## Add the effect to the array duplicating the resource as an instance to
## keep each resource independent from each other.
func add_effect(effect: AbilityEffect) -> void:
	if effect == null:
		push_error("AbilityEffectManager: Cannot add a null effect!")
		return

	var instance: AbilityEffect = effect.duplicate(true)
	instance.initialize()

	active_effects.append(instance)

## This will be called when the ability is activated to modify the ability roll.
## Running through eac effect and apply it effects on top of the ability.
func modify_ability_roll(abroll: AbilityRoll) -> AbilityRoll:
	for effect in active_effects:
		for i in range(effect.dupes):
			effect.ability_roll_modifier.modify_ability_roll(abroll)
	
	return abroll
	
func _process(delta: float) -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		var effect := active_effects[i]

		effect.remaining_time -= delta
		effect.on_tick(get_parent(), delta)

		if effect.remaining_time <= 0.0:
			effect.on_remove(get_parent())
			active_effects.remove_at(i)
	
