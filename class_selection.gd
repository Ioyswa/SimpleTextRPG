extends Control

@onready var container = $CanvasLayer/Panel/Control/ClassListContainer
@onready var class_info_label = $CanvasLayer/Panel/Control/ClassInfoPanel/ClassInfo

var class_info = []
var existing_data

func _ready():
	#$CanvasLayer/Panel/PlayerName.text
	print()
	for i in ClassData.class_list:
		var button = Button.new()
		container.add_child(button)
		button.add_theme_font_size_override("font_size", 32)
		button.text = str(i)
		button.mouse_entered.connect(show_class_info.bind(i))
		button.pressed.connect(set_player_class.bind(i))
		
func show_class_info(name_of_class: String):
	class_info_label.text = get_class_info(name_of_class)
	

func get_class_info(name_of_class: String) -> String:
	var class_data = ClassData.class_list[name_of_class]
	var stats = class_data["Stats"]
	
	
	
	var class_label_text = "Strength: " + str(stats["str"]) + "\n" + "Agility: " + str(stats["agi"]) + "\n" + "Intelligence: " + str(stats["int"]) + "\n" + "Weapon: " + class_data["Weapon"]
	
	return class_label_text
	

func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()

func set_player_class(name_of_class: String):
	PlayerData.player_data["player_class"] = name_of_class
	PlayerData.player_data["player_stats"] = set_player_stats(name_of_class)
	PlayerData.player_data["player_backpack"] = set_player_starter_gear(name_of_class)
	PlayerData.player_data["player_item"] = set_player_equiped_item()
	#print(PlayerData.player_data)
	save_data(PlayerData.player_data["save_slot"], PlayerData.player_data)
	get_tree().change_scene_to_file("res://Scene/main.tscn")

func set_player_stats(name_of_class: String) -> Dictionary:
	var player_stats = {}
	match name_of_class:
		"Warrior":
			player_stats = ClassData.class_list[name_of_class]
		"Archer":
			player_stats = ClassData.class_list[name_of_class]
		"Mage":
			player_stats = ClassData.class_list[name_of_class]
	
	return player_stats
	
func set_player_starter_gear(name_of_class: String) -> Dictionary:
	var player_gear = {}
	match name_of_class:
		"Warrior":
			player_gear = EquipmentData.starter_gear["Warrior"]
		"Archer":
			player_gear = EquipmentData.starter_gear["Archer"]
		"Mage":
			player_gear = EquipmentData.starter_gear["Mage"]
			
	return player_gear


func set_player_equiped_item() -> Dictionary:
	var player_equiped = {
		"Helmet": null,
		"Chestplate": null,
		"Legging": null,
		"Boots": null,
		"Weapon": null
	}
	
	return player_equiped
