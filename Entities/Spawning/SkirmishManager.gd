class_name SkirmishManager extends Node2D


## Enemy type and amount of enemies.
@export var enemies = {} as Dictionary[PackedScene, int]


var enemy_instances = [] as Array[Entity]


func _ready() -> void:
	#spawn_enemies()
	pass

func spawn_enemies() -> void:
	for enemy_type in enemies.keys():
		var example = enemy_type.instantiate() as Entity
		var amt = enemies.get(enemy_type)
		amt *= example.director.population_mult
		
		_spawn_dupes(enemy_type, example, amt)

func _spawn_dupes(enemy_type: PackedScene, example: Entity, amt: int) -> void:
	var spawners = get_children() as Array
	for i in range(amt):
		var enemy = enemy_type.instantiate() as Entity
		var spawner = spawners.pick_random() as Node2D
		enemy.global_position = spawner.global_position
		
		## If the enemy is an "extra" enemy, it does not drop anything.
		if floor(fmod(i, example.director.population_mult)) != 0:
			enemy.drop_tables.clear()
		
		enemy_instances.append(enemy)
		get_tree().root.add_child.call_deferred(enemy)
