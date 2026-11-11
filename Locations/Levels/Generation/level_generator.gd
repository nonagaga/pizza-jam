class_name LevelGenerator extends Node2D

@export var max_rooms : int = 10
@export_dir var room_resource_directory : String
@export var room_scene : PackedScene
@export var hallway_scene : PackedScene
@export var room_size : int = 32 * 10
@export var room_spacing : int = 32 * (10 + 3)
@export var seed_index : int = 55

## Level Generator uses The binding of Isacc Algorithm described here:
## https://www.boristhebrave.com/2020/09/12/dungeon-generation-in-binding-of-isaac/
func _generate() -> Array[bool]:
	var map : Array[bool]
	var room_count : int = 0
	var q : Array[int] = []
	
	map.resize(100)
	
	# start with the center of the map
	q.push_back(seed_index)
	
	# main generation loop
	while(not q.is_empty()):
		# standard queue shenanigans
		var cell : int = q.pop_front()
		
		map[cell] = true
		room_count += 1
		
		var neighbors := _get_neighbors(cell)
		for neighbor :int in neighbors:
			
			if(neighbor == -1):
				continue
			
			if room_count >= max_rooms:
				q.clear()
				break
			
			# if neighbor already occupied
			if map[neighbor]:
				continue
			# if more than one neighbor occupied
			if _neighbors_occupied(neighbor, map) > 1:
				continue
			# randomly give up 50% of the time
			if randf() < 0.5:
				continue
				
			q.push_back(neighbor)
	
	if room_count < max_rooms:
		printerr("Insufficient Room Count. Regenerating...")
		return _generate()
	
	return map
	
func _render_rooms(map : Array[bool], rooms : Array[RoomResource]):
	# draw in rooms
	for i in range(map.size()):
		if(not map[i]):
			continue
		var x = i % 10
		@warning_ignore("integer_division")
		var y = i / 10
		
		var room_instance := room_scene.instantiate() as Node2D
		add_child(room_instance)
		room_instance.position = room_spacing * Vector2(x - seed_index % 10, y - seed_index / 10)
		
		# add hallways
		# if south neighbor exists
		if(i+10 < 100 and map[i+10]):
			var hallway_x : int = int(room_instance.position.x) + 5*32
			var hallway_y : int = int(room_instance.position.y) + 9*32
			var hallway_instance := hallway_scene.instantiate() as Node2D
			add_child(hallway_instance)
			hallway_instance.position = Vector2(hallway_x, hallway_y)
		# if west neighbor exists
		if(i - 1 > 0 and map[i-1]):
			var hallway_x : int = int(room_instance.position.x) + 32
			var hallway_y : int = int(room_instance.position.y) + 5*32
			var hallway_instance := hallway_scene.instantiate() as Node2D
			add_child(hallway_instance)
			hallway_instance.position = Vector2(hallway_x, hallway_y)
			hallway_instance.rotation_degrees = 90
	
# returns neighbors in N E S W order
func _get_neighbors(cell : int) -> Array[int]:
	var neighbors : Array[int] = [-1, -1, -1, -1]
	
	if(cell - 10 > 0):
		neighbors[0] = (cell - 10)
	if(cell + 1 < 10):
		neighbors[1] = (cell + 1)
	if(cell + 10 < 100):
		neighbors[2] = (cell + 10) 
	@warning_ignore("integer_division")
	if(cell - 1 > cell/10):
		neighbors[3] = (cell - 1) 
		
	return neighbors

func _neighbors_occupied(cell: int, map : Array[bool]) -> int:
	var count : int = 0
	for neighbor in _get_neighbors(cell):
		if neighbor == -1:
			continue
		if(map[neighbor]):
			count += 1
	return count
	
func _load_room_resources() -> Array[RoomResource]:
	var resources: Array[RoomResource] = []
	var file_names := DirAccess.get_files_at(room_resource_directory)
	
	for file_name in file_names:
		# Strip export-generated suffixes so ResourceLoader can resolve the original path
		var clean_name := file_name.trim_suffix(".import").trim_suffix(".remap").trim_suffix(".uid")
		var full_path := room_resource_directory.path_join(clean_name)
		
		var res := ResourceLoader.load(full_path)
		if res and res is RoomResource and not resources.has(res):
			resources.append(res)
			
	return resources
	
func _ready() -> void:
	var rooms := _load_room_resources()
	var map := _generate()
	_render_rooms(map, rooms)
	
