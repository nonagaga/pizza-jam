class_name Entity extends CharacterBody2D

@export var entity_name = "Unnamed Entity" as String

func _physics_process(delta: float) -> void:
	move_and_slide()
