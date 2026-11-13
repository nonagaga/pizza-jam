extends Node2D

var scene_manager : SceneManager
@export var exit_scene : StringName
@export var exit_data : Dictionary

func setup(
	manager: SceneManager,
	data: Dictionary = {}
) -> void:
	scene_manager = manager

	# Upgrades
	# Effects
	# Level Difficulty


func exit_level() -> void:
	scene_manager.change_scene(exit_scene, scene_manager.default_transition,
	exit_data)
