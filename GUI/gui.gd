extends Control

var content_active: String

var profile_showing := false
var profile_data_alr_show := false
var inventory_showing := false

@onready var inventory = $Content/ProfileAndInventory/InventoryPanel/Inventory

var dummy_weap_data = {
	0 : {
		"Name" : "Wooden Sword",
		"Stats" : {
			"Attack" : 5
		}
	},
	
	1 : {
		"Name" : "Stone Sword",
		"Stats" : {
			"Attack" : 15
		}
	},
	
	2 : {
		"Name" : "Iron Sword",
		"Stats" : {
			"Attack" : 25
		}
	},
	
	3 : {
		"Name" : "Sword Sword",
		"Stats" : {
			"Attack" : 55
		}
	},
	
	4 : {
		"Name" : "Sword Sword God",
		"Stats" : {
			"Attack" : 5555
		}
	},
}


func _ready():
	content_active = "Profile"
	show_content(content_active)

func _unhandled_key_input(event):
	if event.is_action_pressed("open_profile"):
		content_active = "Profile"
		profile_showing = true
		if content_active == "Profile" and profile_showing:
			show_content(content_active)

func show_content(content_name: String):
	match content_name:
		"Profile":
			show_profile()
			show_inventory()
		
		
		
func show_profile():
	$Content/ProfileAndInventory.visible = !$Content/ProfileAndInventory.visible
	


func get_profile_data():
	if PlayerData.player_data == {}:
		return 

	
	var player_data = PlayerData.player_data
	var player_name = player_data["player_name"]
	var player_class = player_data["player_class"]
	var player_class_stats = ClassData.class_list[player_class]["Stats"]
	print(player_class_stats)
	var player_stats = "\n##Strength : " + str(player_class_stats["str"]) + "\n##Agility : " + str(player_class_stats["agi"])  + "\n##Intelligence : " + str(player_class_stats["int"])
	var profile_text = "\nPlayer name : " + player_name + "\nPlayer class : " + player_class + "\nPlayer Stats : " + player_stats
	$Content/ProfileAndInventory/ProfilePanel/ProfileText.text = profile_text

func show_inventory():
	
	if profile_data_alr_show:
		return 
	
	get_profile_data()
	profile_data_alr_show = true
	
	for i in range(dummy_weap_data.size()):
		var test_button = Button.new()
		inventory.add_child(test_button)
		test_button.text = dummy_weap_data[i]["Name"]
	
	
