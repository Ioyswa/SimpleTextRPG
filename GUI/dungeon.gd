extends Control

var player_data = PlayerData.player_data
var dungeon_reward = PlayerData.dungeon_reward
var player_stats = player_data["player_stats"]
var player_exp = player_stats["Experience"]

func _ready():
	show_dungeon_list()

func save_data(save_slot: int, save_data: Dictionary):
	PlayerData.player_data = save_data
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()



func _on_button_pressed():
	
	dungeon_reward["item"] = {
		"test_item": randi() % 6,
		"slime_soul": randi_range(1, 5)
	}
	dungeon_reward["exp"] = snappedf(randf_range(2.0, 5.0), 0.1)
	dungeon_reward["gold"] = snappedf(randf_range(500.0, 1000.0), 0.1)
	
	show_reward(dungeon_reward)
	
	var gui = get_parent().get_parent()
	gui.get_dungeon_reward(dungeon_reward)
	
	#save_data(PlayerData.player_data["save_slot"], PlayerData.player_data)

func show_reward(dungeon_reward: Dictionary):
	var reward_text = "REWARD: \n\n"
	
	if "item" in dungeon_reward and dungeon_reward["item"].size() > 0:
		reward_text += "Items:\n"
		for item_name in dungeon_reward["item"].keys():
			var item_quantity = dungeon_reward["item"][item_name]
			reward_text += "#" + item_name.replace("_", " ").capitalize() + " x" + str(item_quantity) + "\n"
		reward_text += "\n"
	
	
	if "exp" in dungeon_reward and dungeon_reward["exp"] > 0:
		reward_text += "Exp: " + str(dungeon_reward["exp"]) + " XP\n"
	
	if "gold" in dungeon_reward and dungeon_reward["gold"] > 0:
		reward_text += "Gold: " + str(dungeon_reward["gold"]) + "$"

	$ShowReward/RewardText.text = reward_text
	$ShowReward.visible = true

func _on_close_reward_pressed():
	$ShowReward.visible = false

func show_dungeon_list():
	for dungeon in DungeonData.dungeon_data.keys():
		var button = Button.new()
		var dungeon_name = dungeon.replace("_", " ").capitalize()
		button.text = dungeon_name
		button.pressed.connect(show_monster_list.bind(dungeon))
		$DungeonList.add_child(button)

func show_monster_list(dungeon_name: String):
	#print(dungeon_name)
	for child in $MonsterList.get_children():
		if child is Button:
			child.queue_free()
	
	var monster_list = DungeonData.dungeon_data[dungeon_name]["monster_list"]
	match dungeon_name:
		"dungeon_1":
			for monster_name in monster_list.keys():
				var button = Button.new()
				button.text = monster_name
				$MonsterList.add_child(button)
		"dungeon_2":
			for monster_name in monster_list.keys():
				var button = Button.new()
				button.text = monster_name
				$MonsterList.add_child(button)
