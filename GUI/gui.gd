extends Control

var content_active: String

var profile_showing := false
var inventory_showing := false
var profile_data_alr_show := false
var inventory_data_alr_show := false
var equipment_data_alr_show := false

var equipment_alr_count := false

var equipment_count := 0

var selected_equipment_data = {}
var selected_unequip_item_data = {}

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


func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()

func _on_profile_pressed():
	content_active = "Profile";
	profile_showing = true
	if content_active == "Profile" and profile_showing:
			show_content(content_active)

func _on_inven_pressed():
	content_active = "Inventory"
	inventory_showing = true
	if content_active == "Inventory" and inventory_showing:
		show_content(content_active)

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
		var item = player_backpack[item_type]
		print(item["Status"])
		var item_status = item["Status"]
		if item_status == "Not Equip":
			var item_name = item["Name"]
			var item_button = Button.new()
			inventory.add_child(item_button)
			item_button.text = item_name
			var item_stats = item["Stats"]
			
			for stats_name in item_stats.keys():
				var stats_value = item_stats[stats_name]
				item_button.mouse_entered.connect(show_item_info.bind(item_type, item_name, str(stats_value)))
				item_button.pressed.connect(set_selected_equipment.bind(item_type, item_name, str(stats_value)))
			
	
	
func get_equipment_data():
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.hide()
	$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.show()
	
	if PlayerData.player_data == {}:
		return
	
	var player_item = PlayerData.player_data["player_item"]
	var equipment_names = ["Helmet", "Chestplate", "Legging", "Boots", "Weapon"]
	var equipment_count = 0

	for equipment_name in equipment_names:
		var equipment = player_item[equipment_name]
	
		if equipment == null: 
			equipment = "None"
		else:
			equipment_count += 1
	
		if equipment_data_alr_show == false:
			var equipment_button = Button.new()
			equipment_button.text = equipment_name + " : " + equipment
			equipment_button.pressed.connect(set_selected_unequip_item.bind(equipment_name, equipment))
			$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.add_child(equipment_button)

	equipment_data_alr_show = true

func get_profile_data():
	$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.hide()
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.show()
	
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


func set_selected_equipment(item_type: String, item_name: String, item_stats: String):
	print(item_name)
	selected_equipment_data["item_type"] = item_type
	selected_equipment_data["item_name"] = item_name
	selected_equipment_data["item_stats"] = item_stats

		

func show_item_info(item_type: String, item_name: String, item_stats: String):
	var item_info = "Item Type : " + item_type + "\nItem Name : " + item_name + "\nItem Stats : " + item_stats

	$Content/ProfileAndInventory/Inventory/ItemDetailPanel/ItemDetailText.text = item_info

func set_selected_unequip_item(item_type: String, item_name: String):
	print(item_type)
	selected_unequip_item_data["item_type"] = item_type
	selected_unequip_item_data["item_name"] = item_name

	
	
	
	
func item_unequip():
	if selected_unequip_item_data == {}:
		return
		
	var player_backpack = PlayerData.player_data["player_backpack"]
	var player_item = PlayerData.player_data["player_item"]
	
	var item_name = selected_unequip_item_data["item_name"]
	var item_type = selected_unequip_item_data["item_type"]
	
	player_item[item_type] = "None"
	player_backpack[item_type]["Status"] = "Not Equip"
	
	save_data(PlayerData.player_data["save_slot"], PlayerData.player_data)
	selected_unequip_item_data == {}
	update_equipment()
	update_backpack()

func item_equip():
	if selected_equipment_data == {}:
		return
	
	var player_backpack = PlayerData.player_data["player_backpack"]
	var player_item = PlayerData.player_data["player_item"]
	
	var item_name = selected_equipment_data["item_name"]
	var item_type = selected_equipment_data["item_type"]
	
	
	player_item[item_type] = item_name
	player_backpack[item_type]["Status"] = "Equiped"
	
	save_data(PlayerData.player_data["save_slot"], PlayerData.player_data)
	
	selected_equipment_data == {}
	update_equipment()
	update_backpack()
	
	
	
func update_backpack():
	get_tree().reload_current_scene()
	#var player_backpack = PlayerData.player_data["player_backpack"]
	#
	#for item_type in player_backpack.keys():
		#var item = player_backpack[item_type]
		#print(item["Status"])
		#var item_status = item["Status"]
		#if item_status == "Not Equip":
			#var item_name = item["Name"]
			#var item_button = Button.new()
			#inventory.add_child(item_button)
			#item_button.text = item_name
			#var item_stats = item["Stats"]
			#
			#for stats_name in item_stats.keys():
				#var stats_value = item_stats[stats_name]
				#item_button.mouse_entered.connect(show_item_info.bind(item_type, item_name, str(stats_value)))
				#
	
func update_equipment():
	if PlayerData.player_data == {}:
		return
	
	var player_item = PlayerData.player_data["player_item"]
	var equipment_names = ["Helmet", "Chestplate", "Legging", "Boots", "Weapon"]
	var equipment_count = 0

	for equipment_name in equipment_names:
		var equipment = player_item[equipment_name]
	
		if equipment == null: 
			equipment = "None"
		else:
			equipment_count += 1
	
		if equipment_data_alr_show == false:
			var equipment_button = Button.new()
			equipment_button.text = equipment_name + " : " + equipment
			equipment_button.pressed.connect(set_selected_unequip_item.bind(equipment_name, equipment))
			$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.add_child(equipment_button)

	equipment_data_alr_show = true
