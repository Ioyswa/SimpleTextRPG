extends Control

var save_slot = PlayerData.player_data["save_slot"]

var player_data = PlayerData.player_data
var dungeon_reward = PlayerData.dungeon_reward
var player_stats = player_data["player_stats"]

func _ready():
	show_dungeon_list()

func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()


func show_reward(dungeon_reward: Dictionary):
	var gui = get_parent().get_parent()
	gui.get_dungeon_reward(dungeon_reward)
	var reward_text = "REWARD: \n\n"
	
	for key in dungeon_reward.keys():
		if key != "Gold" and key != "Exp":
			var item_quantity = dungeon_reward[key]
			reward_text += key + " : " + str(item_quantity) + "\n"
			

	if "Exp" in dungeon_reward and dungeon_reward["Exp"] > 0:
		reward_text += "Exp: " + str(dungeon_reward["Exp"]) + " XP\n"
	
	if "Gold" in dungeon_reward and dungeon_reward["Gold"] > 0:
		reward_text += "Gold: " + str(dungeon_reward["Gold"]) + "$"
	
	
	$ShowReward/RewardText.text = reward_text
	$ShowReward.visible = true
	save_data(save_slot, PlayerData.player_data)

func _on_close_reward_pressed():
	$ShowReward.visible = false

func show_dungeon_list():
	for dungeon in DungeonData.dungeon_data.keys():
		var button = Button.new()
		var dungeon_name = dungeon.replace("_", " ").capitalize()
		button.text = dungeon_name
		button.pressed.connect(show_dungeon_content.bind(dungeon))
		$DungeonList.add_child(button)

func show_dungeon_content(dungeon_name: String):
	for child in $MonsterList.get_children():
		if child is Button:
			child.queue_free()
			
	for child in $EnvList.get_children():
		if child is Button:
			child.queue_free()
	
	var type: String
	var monster_list = DungeonData.dungeon_data[dungeon_name]["monster_list"]
	var env_list = DungeonData.dungeon_data[dungeon_name]["env_list"]
	match dungeon_name:
		"dungeon_1":
			for monster_name in monster_list.keys():
				type = "monster"
				var button = Button.new()
				button.text = monster_name
				button.pressed.connect(show_action_and_info.bind(monster_list[monster_name], type, monster_name, dungeon_name))
				button.pressed.connect(set_button_data.bind(type, monster_name, dungeon_name))
				$MonsterList.add_child(button)
			
			for env_name in env_list.keys():
				type = "env"
				var button = Button.new()
				button.text = env_name
				button.pressed.connect(show_action_and_info.bind(env_list[env_name], type, env_name, dungeon_name))
				button.pressed.connect(set_button_data.bind(type, env_name, dungeon_name))
				$EnvList.add_child(button)
			
		"dungeon_2":
			for monster_name in monster_list.keys():
				var button = Button.new()
				button.text = monster_name
				$MonsterList.add_child(button)

func show_action_and_info(information: Dictionary, type: String, obj_name: String, dungeon_name: String):
	$ActionPanel/ActionButton.add_theme_font_size_override("font_size", 24)
	match type:
		"monster":
			$ActionPanel/ActionButton.text = "Attack"
		"env":
			$ActionPanel/ActionButton.text = "Harvest"

	var info_text = ""
	var obj_info = DungeonData.dungeon_data[dungeon_name][type + "_list"][obj_name]
	#print(obj_info)
	var obj_stats = {}
	
	if "stats" in obj_info:
		obj_stats = obj_info["stats"]
		info_text += "##Stats \n"
	
	var obj_drop_list = obj_info["drop_list"]
	if "Health" in obj_stats.keys() and obj_stats != {}:
		info_text += "#Health" + str(obj_stats["Health"]) + "\n\n\n"

	for drop_name in obj_drop_list.keys():
		var drop_range = [obj_drop_list[drop_name]["min"], obj_drop_list[drop_name]["max"]]
		var drop_chance = obj_drop_list[drop_name]["chance"]
		var new_drop_name = drop_name.replace("_", " ").capitalize()
		info_text += new_drop_name + " drop From " + str(drop_range[0]) + " To " + str(drop_range[1]) + " With " + str(drop_chance) + "% Chance" + "\n"
		

	$InformationPanel/InformationLabel.text = info_text


func set_button_data(type: String, obj_name: String, dungeon_name: String):
	$ActionPanel/ActionButton.pressed.disconnect(attack_monster)
	$ActionPanel/ActionButton.pressed.disconnect(harvest_env)
	match type:
		"monster":
			$ActionPanel/ActionButton.pressed.connect(attack_monster.bind(dungeon_name, obj_name))
		"env":
			$ActionPanel/ActionButton.pressed.connect(harvest_env.bind(dungeon_name, obj_name))

func attack_monster(dungeon_name: String, monster_name: String):
	get_tree().change_scene_to_file("res://Scene/battle.tscn")
	#PlayerData.set_player_levelup_requirement()
	#PlayerData.get_player_level()
	#var rewards = DungeonData.kill_monster(dungeon_name, monster_name)
	#show_reward(rewards)

func harvest_env(dungeon_name: String, env_name: String):
	PlayerData.set_player_levelup_requirement()
	PlayerData.get_player_level()
	var rewards = DungeonData.harvest_environment(dungeon_name, env_name)
	show_reward(rewards)
	#print(rewards)
