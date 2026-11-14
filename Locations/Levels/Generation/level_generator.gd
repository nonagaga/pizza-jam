class_name LevelGenerator extends Node2D

@export var max_rooms : int = 10
@export_dir var room_resource_directory : String
@export var starting_room : PackedScene
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
		
		if(not map[cell]):
			room_count += 1
			
		map[cell] = true
		
		if room_count >= max_rooms:
				q.clear()
				break
		
		var neighbors := _get_neighbors(cell)
		neighbors.shuffle()
		for neighbor :int in neighbors:
			
			if(neighbor == -1):
				continue
			
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
	
func _render_rooms(map : Array[bool], rooms : Array[Room]):
	# draw in rooms
	for i in range(map.size()):
		if(not map[i]):
			continue
			
		var x = i % 10
		@warning_ignore("integer_division")
		var y = i / 10
		
		var room_instance : Room
		# if this is the starting room...
		if i == seed_index:
			room_instance = starting_room.instantiate()
		else:
			# add in logic to select room based on neighbors
			var room_resource := _select_room_at_idx(i, map, rooms)
			room_instance = room_resource.duplicate(Node.DUPLICATE_USE_INSTANTIATION)
			
		add_child(room_instance)
		
		# lock all the doors that aren't being used
		var doors_to_lock : int = 0
		var neighbors := _get_neighbors(i)
		for j in range(neighbors.size()):
			var neighbor = neighbors[j]
			if neighbor == -1 or not map[neighbor]:
				# this is a quick way to use the NESW order to convert array
				# position to DoorDir Enum
				doors_to_lock += 1 << j
		# after determining which doors to lock, lock them all at once
		room_instance.lock_doors(doors_to_lock)
		
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

## Selects a room to spawn at an index, typically based on its neighbors
func _select_room_at_idx(cell : int, map: Array[bool], rooms : Array[Room]) -> Room:
	# returns neighbors in N E S W order
	var neighbors := _get_neighbors(cell)
	# integer that contains enum flags for whether has north, east, south, or west door
	var door_dirs : int = 0
	
	# if north neighbor
	if neighbors[0] != -1 and map[neighbors[0]]: door_dirs += Room.DoorDir.NORTH
	# if east neighbor
	if neighbors[1] != -1 and map[neighbors[1]]: door_dirs += Room.DoorDir.EAST
	# if south neighbor
	if neighbors[2] != -1 and map[neighbors[2]]: door_dirs += Room.DoorDir.SOUTH
	# if west neighbor
	if neighbors[3] != -1 and map[neighbors[3]]: door_dirs += Room.DoorDir.WEST
	
	# filter possible rooms by whether they contain the right doors
	var filtered_rooms = rooms.filter(func(elem : Room): return elem.does_contain_doors(door_dirs))
	if filtered_rooms.size() == 0:
		printerr("All rooms filtered!")
		return null
		
	return filtered_rooms[randi_range(0, filtered_rooms.size()-1)]
	
# returns neighbors in N E S W order
func _get_neighbors(cell : int) -> Array[int]:
	var neighbors : Array[int] = [-1, -1, -1, -1]
	
	if(cell - 10 > 0):
		neighbors[0] = (cell - 10)
	@warning_ignore("integer_division")
	if((cell + 1)/10 == cell/10):
		neighbors[1] = (cell + 1)
	if(cell + 10 < 100):
		neighbors[2] = (cell + 10) 
	@warning_ignore("integer_division")
	if((cell - 1)/10 == cell/10):
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
	
func _load_room_scenes() -> Array[Room]:
	var packed_scenes: Array[PackedScene] = []
	var file_names := DirAccess.get_files_at(room_resource_directory)
	
	for file_name in file_names:
		# Strip export-generated suffixes so ResourceLoader can resolve the original path
		var clean_name := file_name.trim_suffix(".import").trim_suffix(".remap").trim_suffix(".uid")
		var full_path := room_resource_directory.path_join(clean_name)
		
		var res := ResourceLoader.load(full_path, "PackedScene") as PackedScene
		if res and not packed_scenes.has(res) and res != starting_room:
			packed_scenes.append(res)
	
	var room_scenes : Array[Room] = []
	for scene in packed_scenes:
		var room := scene.instantiate() as Room
		if room:
			room_scenes.push_back(room)
	
	return room_scenes
	
func _ready() -> void:
	var rooms := _load_room_scenes()
	var map := _generate()
	_render_rooms(map, rooms)
	
