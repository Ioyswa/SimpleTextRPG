extends Control

var content_active: String

var profile_showing := false
var inventory_showing := false
var profile_data_alr_show := false
var inventory_data_alr_show := false

var selected_equipment : String
var selected_equipment_data = {}

@onready var inventory = $Content/ProfileAndInventory/Inventory/InventoryPanel/Inventory
@onready var equip_button = $Content/ProfileAndInventory/Inventory/InventoryPanel/InventoryActionPanel/Equip

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




func _unhandled_key_input(event):
	if event.is_action_pressed("open_profile"):
		content_active = "Profile"
		profile_showing = true
		if content_active == "Profile" and profile_showing:
			show_content(content_active)
	if event.is_action_pressed("open_inventory"):
		content_active = "Inventory"
		inventory_showing = true
		if content_active == "Inventory" and inventory_showing:
			show_content(content_active)

func show_content(content_name: String):
	match content_name:
		"Profile":
			show_profile()
		"Inventory":
			show_inventory()
		
		

func show_equipment():
	get_equipment_data()

func show_profile():
	$Content/ProfileAndInventory/Profile.visible = !$Content/ProfileAndInventory/Profile.visible
	get_profile_data()
	profile_data_alr_show = true
	

func _on_stats_pressed():
	get_profile_data()

func _on_equipment_pressed():
	show_equipment()


func show_inventory():
	$Content/ProfileAndInventory/Inventory.visible = !$Content/ProfileAndInventory/Inventory.visible
	
	if inventory_data_alr_show:
		return
	
	inventory_data_alr_show = true
	var connected = false
	

	var player_backpack = PlayerData.player_data["player_backpack"]
	
	for item_type in player_backpack.keys():
		for item_id in player_backpack[item_type].keys():
			var item = player_backpack[item_type][item_id]
			var item_status = item["Status"]
			if item_status == "Not Equip":
				var item_name = item["Name"]
				var item_button = Button.new()
				inventory.add_child(item_button)
				item_button.text = item_name
				
				var item_stats = item["Stats"]
				
				for stats_name in item_stats.keys():
					var stats_value = item_stats[stats_name]
					item_button.mouse_entered.connect(show_item_info.bind(item_id, item_type, item_name, str(stats_value)))
						
			
	
	
	

func get_equipment_data():
	if PlayerData.player_data == {}:
		return
	
	var player_item = PlayerData.player_data["player_item"]
	var player_helmet = player_item["Helmet"]
	var player_chestplate = player_item["Chestplate"]
	var player_legging = player_item["Legging"]
	var player_boots = player_item["Boots"]
	var player_weapon = player_item["Weapon"]
		
	
	if player_helmet == null: player_helmet = "None"
	if player_chestplate == null: player_chestplate = "None"
	if player_legging == null: player_legging = "None"
	if player_boots == null: player_boots = "None"
	if player_weapon == null: player_weapon = "None"
	
	var equipment_text = "Helmet : " + player_helmet + "\nChestplate : " + player_chestplate + "\nLegging : " + player_legging + "\nBoots : " + player_boots + "\nWeapon : " + player_weapon
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.text = equipment_text

func get_profile_data():
	if PlayerData.player_data == {}:
		return 
	
	var player_data = PlayerData.player_data
	var player_name = player_data["player_name"]
	var player_class = player_data["player_class"]
	var player_class_stats = ClassData.class_list[player_class]["Stats"]
	#print(player_class_stats)
	var player_stats = "\n##Strength : " + str(player_class_stats["str"]) + "\n##Agility : " + str(player_class_stats["agi"])  + "\n##Intelligence : " + str(player_class_stats["int"])
	var profile_text = "\nPlayer name : " + player_name + "\nPlayer class : " + player_class + "\nPlayer Stats : " + player_stats
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.text = profile_text


func show_item_info(item_id: String, item_type: String, item_name: String, item_stats: String):
	var item_info = "Item id : " + item_id + "\nItem Type : " + item_type + "\nItem Name : " + item_name + "\nItem Stats : " + item_stats
	selected_equipment = item_info
	selected_equipment_data["item_id"] = item_id
	selected_equipment_data["item_type"] = item_type
	selected_equipment_data["item_name"] = item_name
	selected_equipment_data["item_stats"] = item_stats
	$Content/ProfileAndInventory/Inventory/ItemDetailPanel/ItemDetailText.text = item_info
		
func item_equip():
	if selected_equipment == "":
		return
	
	var player_backpack = PlayerData.player_data["player_backpack"]
	var player_item = PlayerData.player_data["player_item"]
	
	var item_id = selected_equipment_data["item_id"]
	var item_name = selected_equipment_data["item_name"]
	var item_type = selected_equipment_data["item_type"]
	
	
	player_item[item_type] = item_name
	player_backpack[item_type][item_id]["Status"] = "Equiped"
	
	save_data(PlayerData.player_data["save_slot"], PlayerData.player_data)
	
	get_tree().reload_current_scene()
	
	
func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()
