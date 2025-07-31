extends Control

var save_slot = PlayerData.player_data["save_slot"]

var content_active: String

var profile_showing := false
var inventory_showing := false
var dungeon_showing := false
var backpack_showing := false
var profile_data_alr_show := false
var inventory_data_alr_show := false
var equipment_data_alr_show := false

var equipment_alr_count := false

var equipment_count := 0

var selected_equipment_data = {}
var selected_unequip_item_data = {}

@onready var inventory = $Content/ProfileAndInventory/Inventory/InventoryPanel/Inventory
@onready var equip_button = $Content/ProfileAndInventory/Inventory/InventoryPanel/InventoryActionPanel/Equip



func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()

func _on_main_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func _on_profile_pressed():
	content_active = "Profile";
	profile_showing = true
	if content_active == "Profile" and profile_showing:
		show_content(content_active)

func _on_inven_pressed():
	update_stats()
	content_active = "Inventory"
	inventory_showing = true
	if content_active == "Inventory" and inventory_showing:
		show_content(content_active)

func _on_dungeon_pressed():
	content_active = "Dungeon"
	dungeon_showing = true
	if content_active == "Dungeon" and dungeon_showing:
		show_content(content_active)


func _on_backpack_pressed():
	content_active = "Backpack"
	backpack_showing = true
	if content_active == "Backpack" and backpack_showing:
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
			$Content/Dungeon.visible = false
			show_profile()
		"Inventory":
			$Content/Dungeon.visible = false
			$Content/Backpack.visible = false
			show_inventory()
		"Dungeon":
			$Content/ProfileAndInventory/Inventory.visible = false
			$Content/ProfileAndInventory/Profile.visible = false
			$Content/Backpack.visible = false
			show_dungeon()
		"Backpack":
			$Content/Dungeon.visible = false
			$Content/ProfileAndInventory/Inventory.visible = false
			show_backpack()
		
		
func show_dungeon():
	$Content/Dungeon.visible = !$Content/Dungeon.visible

func show_backpack():
	$Content/Backpack.visible = !$Content/Backpack.visible
	
	show_backpack_content()
	
func show_backpack_content():
	var player_backpack = PlayerData.player_data["player_backpack"]
	var backpack_text = "Items \n\n"
	for items in player_backpack.keys():
		var quantity = player_backpack[items]
		backpack_text += items + " : " + str(quantity) + "\n"
	$Content/Backpack/BackpackPanel/BackpackLabel.text = backpack_text
	

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
	

	var player_inventory = PlayerData.player_data["player_inventory"]
	
	for item_type in player_inventory.keys():
		var item = player_inventory[item_type]
		var item_status = item["Status"]
		if item_status == "Not Equip":
			var item_name = item["Name"]
			var item_button = Button.new()
			inventory.add_child(item_button)
			item_button.text = item_name
			var item_stats = item
			
			for stats_name in item_stats.keys():
				var stats_value = item_stats[stats_name]
				item_button.mouse_entered.connect(show_item_info.bind(item_type, item_name, item_stats))
				item_button.pressed.connect(set_selected_equipment.bind(item_type, item_name, str(stats_value)))
			
	
	
func get_equipment_data():
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.hide()
	$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.show()
	
	if PlayerData.player_data == {}:
		return
	
	var player_equipment = PlayerData.player_data["player_equipment"]
	var equipment_names = ["Helmet", "Chestplate", "Legging", "Boots", "Weapon"]
	var equipment_count = 0

	for equipment_name in equipment_names:
		var equipment = player_equipment[equipment_name]
	
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
	
	var current_player_stats = player_data["player_stats"]
	var current_player_exp = str(player_data["player_exp"])
	var current_player_gold = str(player_data["player_gold"])
	var current_player_level = str(player_data["player_level"])
	var current_levelup_requirement = str(player_data["player_levelup_requirement"])
	
	var player_stats = "\n##Strength : " + str(current_player_stats["Str"]) + "\n##Agility : " + str(current_player_stats["Agi"])  + "\n##Intelligence : " + str(current_player_stats["Int"]) + "\n##Health : " + str(current_player_stats["Health"]) + "\n##Defense : " + str(current_player_stats["Defense"])
	
	if "Attack" in current_player_stats:
		player_stats += "\n##Attack : " + str(current_player_stats["Attack"])
	
	var profile_text = "\nPlayer name : " + player_name + "\nPlayer class : " + player_class + "\nPlayer Stats : " + player_stats
	profile_text +=  "\nPlayer Level : " + current_player_level +  "\nPlayer Gold : " + current_player_gold + "\nPlayer Exp : " + current_player_exp + "/" + current_levelup_requirement 
	$Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.text = profile_text

	
func set_selected_equipment(item_type: String, item_name: String, item_stats: String):
	selected_equipment_data["item_type"] = item_type
	selected_equipment_data["item_name"] = item_name
	selected_equipment_data["item_stats"] = item_stats

func show_item_info(item_type: String, item_name: String, item_stats: Dictionary):
	var item: Dictionary
	var num = 0
	var stats_num
	for stats_name in item_stats.keys():
		num += 1
		stats_num = "Stats" + str(num)
		var stats = item_stats[stats_name]
		item[stats_num] = stats_name + " : " + str(stats)

	var stats1 = item["Stats1"]
	var stats2 = item["Stats2"]
	
	var item_info = "Item Type : " + item_type + "\nItem Name : " + item_name + "\nItem Stats : \n" + stats1 + "\n" + stats2
	$Content/ProfileAndInventory/Inventory/ItemDetailPanel/ItemDetailText.text = item_info
	
func set_selected_unequip_item(item_type: String, item_name: String):

	selected_unequip_item_data["item_type"] = item_type
	selected_unequip_item_data["item_name"] = item_name

	
	

	
func item_equip():
	if selected_equipment_data == {}:
		return
	
	var player_inventory = PlayerData.player_data["player_inventory"]
	var player_equipment = PlayerData.player_data["player_equipment"]
	
	var item_name = selected_equipment_data["item_name"]
	var item_type = selected_equipment_data["item_type"]
	
	player_equipment[item_type] = item_name
	player_inventory[item_type]["Status"] = "Equiped"
	
	update_stats()
	
	save_data(save_slot, PlayerData.player_data)
	
	selected_equipment_data = {}
	
	update_equipment()
	update_backpack()

func item_unequip():
	if selected_unequip_item_data == {}:
		return
		
	var player_inventory = PlayerData.player_data["player_inventory"]
	var player_equipment = PlayerData.player_data["player_equipment"]
	
	var item_name = selected_unequip_item_data["item_name"]
	var item_type = selected_unequip_item_data["item_type"]
	
	player_equipment[item_type] = "None"
	player_inventory[item_type]["Status"] = "Not Equip"
	
	update_stats()
	
	save_data(save_slot, PlayerData.player_data)
	
	selected_unequip_item_data = {} 
	
	update_equipment()
	update_backpack()
	
func update_backpack():
	clear_inventory_ui()
	rebuild_inventory_ui()
	if $Content/ProfileAndInventory/Profile.visible:
		refresh_profile_stats()

func clear_inventory_ui():
	for child in inventory.get_children():
		if child is Button:
			child.queue_free()

func rebuild_inventory_ui():
	var player_inventory = PlayerData.player_data["player_inventory"]
	
	for item_type in player_inventory.keys():
		var item = player_inventory[item_type]
		var item_status = item["Status"]
		if item_status == "Not Equip":
			var item_name = item["Name"]
			var item_button = Button.new()
			inventory.add_child(item_button)
			item_button.text = item_name
			var item_stats = item
			
			for stats_name in item_stats.keys():
				var stats_value = item_stats[stats_name]
				item_button.mouse_entered.connect(show_item_info.bind(item_type, item_name, item_stats))
				item_button.pressed.connect(set_selected_equipment.bind(item_type, item_name, str(stats_value)))

func update_equipment():
	clear_equipment_ui()
	rebuild_equipment_ui()

func clear_equipment_ui():
	for child in $Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.get_children():
		if child is Button:
			child.queue_free()

func rebuild_equipment_ui():
	if PlayerData.player_data == {}:
		return
	
	var player_equipment = PlayerData.player_data["player_equipment"]
	var equipment_names = ["Helmet", "Chestplate", "Legging", "Boots", "Weapon"]

	for equipment_name in equipment_names:
		var equipment = player_equipment[equipment_name]
	
		if equipment == null or equipment == "None": 
			equipment = "None"
	
		var equipment_button = Button.new()
		equipment_button.text = equipment_name + " : " + str(equipment)
		equipment_button.pressed.connect(set_selected_unequip_item.bind(equipment_name, equipment))
		$Content/ProfileAndInventory/Profile/ProfilePanel/EquipedItem.add_child(equipment_button)

func refresh_profile_stats():
	if $Content/ProfileAndInventory/Profile/ProfilePanel/ProfileText.visible:
		get_profile_data()

func update_stats():
	var equiped_item = {}
	var player_data = PlayerData.player_data
	var player_inventory = player_data["player_inventory"]
	var player_stats = player_data["player_stats"]
	var player_class = player_data["player_class"]
	
	var base_class_stats = ClassData.class_list[player_class]["Stats"]
	
	var equipment_bonuses = {
		"Health": 0.0,
		"Defense": 0.0,
		"Attack": 0.0,
		"Str": 0.0,
		"Agi": 0.0,
		"Int": 0.0
	}
	
	for item_type in player_inventory.keys():
		var item = player_inventory[item_type]
		if item["Status"] == "Equiped":
			
			equiped_item[item_type] = {
				"Item Name": item["Name"],
				"Item Stats": item
			}
			var item_stats = equiped_item[item_type]["Item Stats"]["Stats"]
		
			for stats_name in item_stats.keys():
				if stats_name in equipment_bonuses:
					equipment_bonuses[stats_name] += item_stats[stats_name]
	
	for stats_name in base_class_stats.keys():
		player_stats[stats_name] = base_class_stats[stats_name] + equipment_bonuses.get(stats_name, 0.0)
	

	if "Attack" not in base_class_stats and equipment_bonuses["Attack"] > 0:
		player_stats["Attack"] = equipment_bonuses["Attack"]
	
	save_data(save_slot, PlayerData.player_data)

func get_dungeon_reward(dungeon_reward: Dictionary):
	var player_backpack = PlayerData.player_data["player_backpack"]
	
	
	for item_name in dungeon_reward.keys():
		if item_name != "Gold" and item_name != "Exp" and item_name != "Message":
			if item_name != "":
				var item_quantity = dungeon_reward[item_name]
				if item_name in player_backpack.keys():
					player_backpack[item_name] += item_quantity
				else:
					player_backpack[item_name] = item_quantity
			
	if "Exp" in dungeon_reward and dungeon_reward["Exp"] > 0:
		PlayerData.player_data["player_exp"] += dungeon_reward["Exp"]
	
	if "Gold" in dungeon_reward and dungeon_reward["Gold"] > 0:
		PlayerData.player_data["player_gold"] += dungeon_reward["Gold"]
		
	save_data(save_slot, PlayerData.player_data)
