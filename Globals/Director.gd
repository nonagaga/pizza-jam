extends Node

# Future-proof list of player data resources
# (can realistically just be a variable instead of dict).
var player_data = {} as Dictionary[int, PlayerData]

func save_carryover_data(entity: Entity) -> void:
	var data := player_data.get_or_add(1, PlayerData.new()) as PlayerData
	
	for eh in entity._effect_holders:
		if !eh.effect.is_permanent:
			continue
		
		# if dupes = 0, then don't add?  I like stacks with 0 personally.
		
		data.permanent_effect_stats.set(eh.effect, eh.dupes)

func write_caryover_data(entity: Entity) -> void:
	var data := player_data.get(1) as PlayerData
	if data == null:
		return
	
	for effect in data.permanent_effect_stats.keys():
		entity.add_effect(effect, data.permanent_effect_stats.get(effect))
