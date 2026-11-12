class_name SceneManager extends Node
## SceneManager singleton used to allow game scenes to load/unload with transitions
##
## Scenes interact with the scenemanager by calling change_scene(...), passing the desired
## scene name as an argument.
## The SceneManager is NOT a global, and references must manually be passed via dependency
## injection. The SceneManager will automatically pass itself if it sees a setup() method 
## (See main_menu.tscn for an example).

@export var scene_list : Dictionary[StringName, PackedScene]
@export var default_transition : PackedScene
@export var default_scene : StringName
@export var canvas_layer : CanvasLayer

func _ready() -> void:
	var default_scene_instance = scene_list[default_scene].instantiate()
	
	if default_scene_instance.has_method("setup"):
		default_scene_instance.setup(self)
		
	add_child(default_scene_instance)

## Takes a StringName, plays a transition, unloads the scene, and swaps to the new one.
## Make sure to register the scene name in the scene_manager.tscn export variable.
func change_scene(scene_name : StringName, 
transition :PackedScene = default_transition, 
data: Dictionary = {}):
	if not scene_name in scene_list:
		printerr("Scene %s not in scene_list! Are you sure you added it 
		correctly to the SceneManager?" % scene_name)
		return
	
	var scene_instance = scene_list[scene_name].instantiate()
	var transition_instance : SceneTransition = transition.instantiate()
	
	canvas_layer.add_child(transition_instance)
	transition_instance.play_outro()
	await transition_instance.on_outro_finished
	
	for child in get_children():
		if not child is CanvasLayer:
			child.queue_free()
			
	# Codex additions passing dependencies and transtion data
	if scene_instance.has_method("setup"):
		scene_instance.setup(self, data)
	
	add_child(scene_instance)
	
	await get_tree().process_frame
	
	transition_instance.play_intro()
	await transition_instance.on_intro_finished
	
	canvas_layer.remove_child(transition_instance)
	transition_instance.queue_free()
