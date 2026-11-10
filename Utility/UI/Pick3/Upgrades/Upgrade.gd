class_name Upgrade
extends Resource
#This is the upgrade resource for when you're prompted to pick 3
#Lots of unique options for modifying stats
#Can also have attached abilities


@export var text:String
@export var rarity:int
@export var tooltip_text:String
@export var icon:Texture2D
@export var health_modifier:int
@export var damage_modifier:int
@export var attack_speed_mult:float
@export var health_mult:float
@export var damage_mult:float

#Should also have an ability attached but I don't have access to that class yet
