class_name AbilityProjectile extends CharacterBody2D

## Rotation based on where the entity was aiming when firing.
var aim_rotation = 0.0 as float
@export var starting_rotation = 0.0 as float
@export var ending_rotation = 0.0 as float

@export var lifetime = 0.5 as float
var _time_alive = 0.0 as float
@export var follows_owner = false as bool

var originator: Entity
var ability_roll: AbilityRoll

func _ready() -> void:
	set_collision_layer_value(9, true)
	set_collision_mask_value(9, true)

func _physics_process(delta: float) -> void:
	rotation_degrees = remap(_time_alive, 0.0, lifetime, starting_rotation, ending_rotation)
	rotation_degrees += aim_rotation
	
	if _time_alive >= lifetime:
		queue_free()
	_time_alive += delta

func set_aim_rotation(direction: Vector2) -> void:
	aim_rotation = rad_to_deg(get_angle_to(direction))


func apply_range_mult(mult: float) -> void:
	scale *= mult
