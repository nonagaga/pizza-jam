class_name Dialogue
extends Resource
@export var text:String
@export var options:Array[DialogueChoice]

@export var exit_scene: StringName = &"Combat"

@export var exit_data: Dictionary = {}

#Simple resource for the dialogue system. The text variable lets you write whatever you'd like the dialogue to say, and the options array lets you include whatever responses to said dialogue you'd
#like if you want a branching dialogue, as in clicking option one leads to different text, or even more options than clicking option one, the dialogue choice has a built in variable that lets you 
#point to a new dialogue.
