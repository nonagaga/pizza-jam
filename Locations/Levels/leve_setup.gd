extends Node2D

var scene_manager : SceneManager
var level_data : Dictionary = {}
@export var exit_scene : StringName
@export var exit_data : Dictionary = {}

func setup(
	manager: SceneManager,
	data: Dictionary = {}
) -> void:
	scene_manager = manager
	level_data = data.duplicate(true)

func _ready() -> void:
	distribute_data(self)

## distributes the data through out the entire scene tree as long as the
## as the respective node has the metho receive_level_data
func distribute_data(node: Node) -> void:
	for child in node.get_children():
		if child.has_method("receive_level_data"):
			child.receive_level_data(level_data)
		
		distribute_data(child)

func collect_data(node: Node)->void:
	for child in node.get_children():
		if child.has_method("distribute_level_data"):
			var data: Dictionary = child.get_level_data()
			
			exit_data.merge(data, true)
			
		collect_data(node)
		
func exit_level() -> void:
	scene_manager.change_scene(exit_scene, scene_manager.default_transition,
	exit_data)
