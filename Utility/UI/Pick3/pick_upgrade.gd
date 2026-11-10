class_name Pick3System
extends Control
##Ui thing which lets you pick one of three randomized upgrades yippee.
##Upgrades are sorted in to several folders based on their rarity more details are in the Upgrade.gd script

@export var option1:Button
@export var option2:Button
@export var option3:Button

var option1_data
var option2_data
var option3_data
var commons
var uncommons
var rares
var legendaries
var selected_data

func _ready() -> void:
	setup_upgrade_lists()
	randomize_option_data()
	setup_option_button(option1,option1_data)
	setup_option_button(option2,option2_data)
	setup_option_button(option3,option3_data)

##iterates through the folders which contain the different upgrade resources and creates a list of each rarity
func setup_upgrade_lists():
	commons = ResourceLoader.list_directory("res://Utility/UI/Pick3/Upgrades/Common/")
	uncommons = ResourceLoader.list_directory("res://Utility/UI/Pick3/Upgrades/Uncommon/")
	rares = ResourceLoader.list_directory("res://Utility/UI/Pick3/Upgrades/Rare/")
	legendaries = ResourceLoader.list_directory("res://Utility/UI/Pick3/Upgrades/Legendary/")

##takes a button, and data, and sets the button up to have the right text, icon, and tooltip
func setup_option_button(button:Button,data):
	button.text = data.text
	button.tooltip_text = data.tooltip_text
	button.icon = data.icon

##randomizes the data for each option in the pick 3 menu
func randomize_option_data():
	option1_data = randomize_option()
	option2_data = randomize_option()
	option3_data = randomize_option()

#yes I know using magic numbers for the rarity is bad practice. since they're so interconnected I think it's best though.
##returns random option data with a bias towards less rare upgrades.
func randomize_option():
	var quality = randi_range(1,100)
	var option_data
	if quality < 50:
		option_data = load("res://Utility/UI/Pick3/Upgrades/Common/" + commons[randi_range(0,commons.size()-1)])
	elif quality < 80:
		option_data = load("res://Utility/UI/Pick3/Upgrades/Uncommon/" + uncommons[randi_range(0,uncommons.size()-1)])
	elif quality < 95:
		option_data = load("res://Utility/UI/Pick3/Upgrades/Rare/" + rares[randi_range(0,rares.size()-1)])
	else:
		option_data = load("res://Utility/UI/Pick3/Upgrades/Legendary/" + legendaries[randi_range(0,legendaries.size()-1)])
	return option_data
	
func close_upgrades():
	pass

func _on_option_1_pressed() -> void:
	selected_data = option1_data
	close_upgrades()


func _on_option_2_pressed() -> void:
	selected_data = option2_data
	close_upgrades()


func _on_option_3_pressed() -> void:
	selected_data = option3_data
	close_upgrades()
