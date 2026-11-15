class_name RoomResource extends Resource

# create enum with flag values 1, 2, 4, 8
enum DoorDir {NORTH = 1 << 0, EAST = 1 << 1, SOUTH = 1 << 2, WEST = 1 << 3}

@export var room_scene : PackedScene
@export_flags("North", "East", "South", "West") var door_directions : int

## returns a list of DoorDir enum values, which describes the doors the room has
func get_door_directions() -> Array[DoorDir]:
	var dirs : Array[DoorDir] = []
	for dir in DoorDir.values():
		if door_directions & dir != 0:
			dirs.push_back(dir)
	return dirs

## getter for packed room scene
func get_room_scene() -> PackedScene:
	return room_scene

## iterates through directions and ensures it has at least target doors
## target_doors stored in enum flag format
func does_contain_doors(target_doors : int) -> bool:
	for dir in DoorDir.values():
		# target contains a door we don't have, so return false
		if target_doors & dir != 0 and door_directions & dir == 0:
			return false
	return true
