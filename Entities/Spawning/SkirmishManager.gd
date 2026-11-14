class_name SkirmishManager extends Node2D


## Enemy type and amount of enemies.
@export var enemies = {} as Dictionary[PackedScene, int]



func _ready() -> void:
	print("hello")
	spawn_enemies()

func spawn_enemies() -> void:
	var spawners = get_children() as Array
	
	for enemy_type in enemies.keys():
		var example = enemy_type.instantiate() as Entity
		var amt = enemies.get(enemy_type)
		amt *= example.director.population_mult
		for i in range(amt):
			var enemy = enemy_type.instantiate() as Entity
			var spawner = spawners.pick_random() as Area2D
			enemy.global_position = spawner.global_position
			get_tree().root.add_child.call_deferred(enemy)
