class_name DialogueChoice
extends Resource
@export var text:String
@export var difficulty_modifier:int
@export var health_modifier:int
@export var boredom_modifier:int
#lets you create branching dialogue trees
@export var linked_dialogue:Dialogue

#Just holds the data for whatever decisions you make in a dialogue. Designed to be easily handled by an as of yet unimplemented ChoiceHandler script, but that's dependant on other parts of the game
#being actually functional. 
