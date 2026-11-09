extends Control
@export var dialogue_box:RichTextLabel
@export var response_box:VBoxContainer
@export var option1:Button
@export var option2:Button
@export var option3:Button
@export var option4:Button
var current_dialogue:Dialogue
#number of characters after which the dialogue system will attempt to cut the current dialogue in to a seperate box
@export var max_chars:int = 200
#where in the current dialogue we are
var current_point:int = 0
var selected_data
var opt1_data
var opt2_data
var opt3_data
var opt4_data

func setup_dialogue(dialogue:Dialogue):
	current_dialogue = dialogue
	current_point = 0 
	option1.visible = false
	option2.visible = false
	option3.visible = false
	option4.visible = false
	iterate_dialogue(dialogue)

#writes the current dialogue to the dialogue box cutting it off when it hits the character limit for said box.
func iterate_dialogue(dialogue:Dialogue):
	if dialogue.text.length() - current_point > max_chars:
		var cut_point = dialogue.text.findn(" ", current_point + max_chars)
		dialogue_box.text = dialogue.text.substr(current_point,cut_point)
		dialogue_box.text = dialogue_box.text + "..."
		current_point = cut_point
	else:
		dialogue_box.text = dialogue.text.substr(current_point,max_chars)
		if dialogue.options.size() >0:
			display_options(dialogue)

#shows the options for the current dialogue and sets up the data for said dialogue to be accurate
func display_options(dialogue:Dialogue):
	var options = dialogue.options
	match dialogue.options.size():
		0:
			pass
		1:
			option1.visible = true
			option1.text = options[0].text
			opt1_data = options[0]
		2:
			option1.visible = true
			option1.text = options[0].text
			opt1_data = options[0]
			option2.visible = true
			option2.text = options[1].text
			opt2_data = options[1]
		3:
			option1.visible = true
			option1.text = options[0].text
			opt1_data = options[0]
			option2.visible = true
			option2.text = options[1].text
			opt2_data = options[1]
			option3.visible = true
			option3.text = options[2].text
			opt3_data = options[2]
		4:
			option1.visible = true
			option1.text = options[0].text
			opt1_data = options[0]
			option2.visible = true
			option2.text = options[1].text
			opt2_data = options[1]
			option3.visible = true
			option3.text = options[2].text
			opt3_data = options[2]
			option4.visible = true
			option4.text = options[3].text
			opt4_data = options[3]
		_:
			printerr("too many options")

func _ready() -> void:
	var dialogue = load("res://Utility/UI/DialogueSystem/Dialogue/TestDialogue.tres")
	setup_dialogue(dialogue)

func close_dialogue():
	pass

#checks if we're left clicking to iterate through dialogue
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Primary Ability") && current_point < current_dialogue.text.length():
		iterate_dialogue(current_dialogue)

func _on_option_1_pressed() -> void:
	selected_data = opt1_data
	if selected_data.linked_dialogue:
		setup_dialogue(selected_data.linked_dialogue)
	else:
		close_dialogue()


func _on_option_2_pressed() -> void:
	selected_data = opt2_data
	if selected_data.linked_dialogue:
		setup_dialogue(selected_data.linked_dialogue)
	else:
		close_dialogue()


func _on_option_3_pressed() -> void:
	selected_data = opt3_data
	if selected_data.linked_dialogue:
		setup_dialogue(selected_data.linked_dialogue)
	else:
		close_dialogue()


func _on_option_4_pressed() -> void:
	selected_data = opt4_data
	if selected_data.linked_dialogue:
		setup_dialogue(selected_data.linked_dialogue)
	else:
		close_dialogue()


#Making custom dialogue should be incredibly easy. The system loads up a "Dialogue" which is a custom resource class you guys can write text for and then automatically cuts it off when appropriate
#If the dialogue resource has any "DialogueChoices", which are another custom resource class, than it will automatically make the relevant buttons available at the end of the dialogue.
#More detailed explanations for the Dialogue and DialogueChoice classes are available in those scripts.
