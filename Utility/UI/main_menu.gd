extends Control

@export var start_button : Button
@export var quit_button : Button
@export var credits_button : Button
var scene_manager : SceneManager

func setup(sm : SceneManager):
	scene_manager = sm

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	scene_manager.change_scene("entity_testing")
