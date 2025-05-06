extends Control

var content_active: String

var profile_showing := false
var profile_data_alr_show := false
var inventory_showing := false

@onready var inventory = $Content/ProfileAndInventory/InventoryPanel/Inventory

var dummy_weap_data = {
	"Sword": {
		0 : {
			"Name" : "Wooden Sword",
			"Stats" : {
				"Attack" : 5,
				"Str" : 20,
			}
		},
		
		1 : {
			"Name" : "Stone Sword",
			"Stats" : {
				"Attack" : 15,
				"Str" : 20,
			}
		},
		
		2 : {
			"Name" : "Iron Sword",
			"Stats" : {
				"Attack" : 25,
				"Str" : 20,
			}
		},
		
		3 : {
			"Name" : "Sword Sword",
			"Stats" : {
				"Attack" : 55,
				"Str" : 20,
			}
		},
		
		4 : {
			"Name" : "Sword Sword God",
			"Stats" : {
				"Attack" : 5555,
				"Str" : 20,
			}
		},
	},
	"Staff": {
		0 : {
			"Name" : "Wooden Staff",
			"Stats" : {
				"Attack" : 5,
				"Int" : 20,
			}
		},
		
		1 : {
			"Name" : "Stone Staff",
			"Stats" : {
				"Attack" : 15,
				"Int" : 20,
			}
		},
		
		2 : {
			"Name" : "Iron Staff",
			"Stats" : {
				"Attack" : 25,
				"Int" : 20,
			}
		},
		
		3 : {
			"Name" : "Staff Staff",
			"Stats" : {
				"Attack" : 55,
				"Int" : 20,
			}
		},
		
		4 : {
			"Name" : "Staff Staff God",
			"Stats" : {
				"Attack" : 5555,
				"Int" : 20,
			}
		},
	},
	"Bow": {
		0 : {
			"Name" : "Wooden Bow",
			"Stats" : {
				"Attack" : 5,
				"Agi" : 20,
			}
		},
		
		1 : {
			"Name" : "Stone Bow",
			"Stats" : {
				"Attack" : 15,
				"Agi" : 20,
			}
		},
		
		2 : {
			"Name" : "Iron Bow",
			"Stats" : {
				"Attack" : 25,
				"Agi" : 20,
			}
		},
		
		3 : {
			"Name" : "Bow Bow",
			"Stats" : {
				"Attack" : 55,
				"Agi" : 20,
			}
		},
		
		4 : {
			"Name" : "Bow Bow God",
			"Stats" : {
				"Attack" : 5555,
				"Agi" : 20,
			}
		},
	},
	
}

var dummy_armor_data = {
	"Helmet": {
		1: {
			"Name": "Wooden Helmet",
			"Stats": {
				"Health": 50,
				"Defense": 20
			}
		},
		2: {
			"Name": "Stone Helmet",
			"Stats": {
				"Health": 70,
				"Defense": 30,
			}
		},
	},
	"Chestplate": {
		1: {
			"Name": "Wooden Chestplate",
			"Stats": {
				"Health": 150,
				"Defense": 50,
			}
		},
		2: {
			"Name": "Stone Chestplate",
			"Stats": {
				"Health": 250,
				"Defense": 100,
			}
		}
	}
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
	
	
	
	for weapon_type in dummy_weap_data.keys():
		for weapon_id in dummy_weap_data[weapon_type].keys():
			var weapon_button = Button.new()
			inventory.add_child(weapon_button)
			weapon_button.text = dummy_weap_data[weapon_type][weapon_id]["Name"]
			weapon_button.mouse_entered.connect(show_item_info.bind(weapon_id, "weapon", "" , weapon_type))
	
	for armor_type in dummy_armor_data.keys():
		for armor_id in dummy_armor_data[armor_type].keys():
			var armor_button = Button.new()
			inventory.add_child(armor_button)
			armor_button.text = dummy_armor_data[armor_type][armor_id]["Name"]
			armor_button.mouse_entered.connect(show_item_info.bind(armor_id, "armor", armor_type, ""))
		
	
	var player_gear = PlayerData.player_data["player_item"]
	
	for gear_type in player_gear.keys():
		print("Gear Type : " + gear_type)
		
		for item_id in player_gear[gear_type].keys():
			var item = player_gear[gear_type][item_id]
			
			
			var item_name = item["Name"]
	
			var item_button = Button.new()
			inventory.add_child(item_button)
			item_button.text = item_name
			
			var item_stats = item["Stats"]
			for stats_name in item_stats.keys():
				var stats_value = item_stats[stats_name]
	
				print(" ", stats_name, ": ", stats_value)

	

func show_item_info(item_id: int, item_type: String, armor_type: String = "", weapon_type: String = ""):
	match item_type:
		"weapon":
			var weapon_info = dummy_weap_data[weapon_type][item_id]
			var weapon_name = weapon_info["Name"]
			var weapon_attack = weapon_info["Stats"]["Attack"]
			var weapon_stats
			match weapon_type:
				"Sword":
					weapon_stats = "Str +" + str(weapon_info["Stats"]["Str"])
				"Staff":
					weapon_stats = "Int +" + str(weapon_info["Stats"]["Int"])
				"Bow":
					weapon_stats = "Agi +" + str(weapon_info["Stats"]["Agi"])
				_:
					return
			$Content/ProfileAndInventory/ItemDetailPanel/ItemDetailText.text = "Weapon Name : " + weapon_name + "\nWeapon Attack : " + str(weapon_attack) + "\nWeapon Stats : " + weapon_stats
		"armor":
			var armor_info = dummy_armor_data[armor_type][item_id]
			var armor_name = armor_info["Name"]
			var armor_health = armor_info["Stats"]["Health"]
			var armor_defense = armor_info["Stats"]["Defense"]
			$Content/ProfileAndInventory/ItemDetailPanel/ItemDetailText.text = "Armor Name : " + armor_name + "\nArmor Health : " + str(armor_health) + "\nArmor Defense : " + str(armor_defense)
			
			
