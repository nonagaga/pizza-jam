class_name SceneManager extends Node

@export var scene_list : Dictionary[StringName, PackedScene]
@export var default_transition : PackedScene
@export var default_scene : StringName

func _ready() -> void:
	var default_scene_instance = scene_list[default_scene].instantiate()
	if default_scene_instance.has_method("setup"):
		default_scene_instance.setup(self)
	add_child(default_scene_instance)

func change_scene(scene_name : StringName, transition :PackedScene = default_transition):
	if not scene_name in scene_list:
		printerr("Scene %s not in scene_list! Are you sure you added it correctly to the SceneManager?" % scene_name)
	
	var scene_instance = scene_list[scene_name].instantiate()
	var transition_instance : SceneTransition = transition.instantiate()
	
	add_child(transition_instance)
	transition_instance.play_outro()
	await transition_instance.on_outro_finished
	for child in get_children():
		if not child is SceneTransition:
			child.queue_free()
	add_child(scene_instance)
	await get_tree().process_frame
	transition_instance.play_intro()
	await transition_instance.on_intro_finished
