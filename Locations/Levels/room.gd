class_name Room extends NavigationRegion2D

enum DoorDir {NORTH = 1 << 0, EAST = 1 << 1, SOUTH = 1 << 2, WEST = 1 << 3}

@export var north_door : StaticBody2D
@export var east_door : StaticBody2D
@export var south_door : StaticBody2D
@export var west_door : StaticBody2D

@export var player_detector : Area2D
## Spawner that adds / removes enemies for this room
@export var spawner : Variant

var is_doors_open = true
var room_cleared = false
var in_fight = false

var doors : Dictionary[DoorDir, StaticBody2D]

## Returns door directions in NESW order
func get_door_dirs() -> int:
	var dirs : int = 0
	if north_door:
		dirs += DoorDir.NORTH
	if east_door:
		dirs += DoorDir.EAST
	if south_door:
		dirs += DoorDir.SOUTH
	if west_door:
		dirs += DoorDir.WEST
	return dirs

func close_door(door :StaticBody2D) -> void:
	if door:
		door.visible = true
		door.process_mode = Node.PROCESS_MODE_ALWAYS

## close doors, before fight
func close_doors() -> void:
	is_doors_open = false
	for door in doors.values():
		# enable the doors collision
		if door is StaticBody2D:
			close_door(door)

## open doors, allowing player to enter / leave
func open_doors() -> void:
	is_doors_open = true
	for door in doors.values():
		if door is StaticBody2D:
			door.visible = false
			door.process_mode = Node.PROCESS_MODE_DISABLED

## function to prevent doors with nothing behind them from opening
## lets connected doors open, while keeping others closed so player can't escape
func lock_doors(locked_doors : int) -> void:
	for key in DoorDir.keys():
		# if door in locked_doors
		var dir = DoorDir.get(key)
		# if door included in locked doors
		# evaluates to true, which is 1 != 0
		if locked_doors & dir != 0:
			var this_door = doors[dir]
			close_door(this_door)
			# remove it from the list of doors so we don't accidentally open it
			doors.erase(dir)
			
## iterates through directions and ensures it has at least target doors
## target_doors stored in enum flag format
func does_contain_doors(target_doors : int) -> bool:
	for dir in DoorDir.values():
		# target contains a door we don't have, so return false
		if target_doors & dir != 0 and get_door_dirs() & dir == 0:
			return false
	return true

func _on_player_detector_entered(body : Node2D):
	if body.is_in_group("Player") and not room_cleared and not in_fight:
		in_fight = true
		## this is our player
		close_doors()
		await get_tree().create_timer(1).timeout
		open_doors()
		room_cleared = true
		in_fight = false

func _register_doors() -> void:
	doors = {
	DoorDir.NORTH: north_door, 
	DoorDir.EAST: east_door, 
	DoorDir.SOUTH: south_door, 
	DoorDir.WEST: west_door
	}

func _ready() -> void:
	_register_doors()
	player_detector.body_entered.connect(_on_player_detector_entered)
	open_doors()
	
	# detect player on first frame
	await get_tree().physics_frame
	for body in player_detector.get_overlapping_bodies():
		_on_player_detector_entered(body)
