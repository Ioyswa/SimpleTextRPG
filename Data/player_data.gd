extends Node

var player_data := {}

var dungeon_reward := {}

func set_player_levelup_requirement():
	player_data["player_levelup_requirement"] = player_data["player_level"] * 100.0
	
func get_player_level():
	player_data["player_level"] = snapped((player_data["player_exp"] / 100.0) + 1, 1)
	set_player_levelup_bonus_stats()
	
func set_player_levelup_bonus_stats():
	match player_data["player_class"]:
		"Archer":
			player_data["player_stats"]["Agi"] += 4 * player_data["player_level"]
			player_data["player_stats"]["Health"] += 2 * player_data["player_level"]
			player_data["player_stats"]["Defense"] += 2 * player_data["player_level"]
		"Warrior":
			player_data["player_stats"]["Str"] += 4 * player_data["player_level"]
			player_data["player_stats"]["Health"] += 4 * player_data["player_level"]
			player_data["player_stats"]["Defense"] += 4 * player_data["player_level"]
		"Mage":
			player_data["player_stats"]["Int"] += 4 * player_data["player_level"]
			player_data["player_stats"]["Health"] += 2 * player_data["player_level"]
			player_data["player_stats"]["Defense"] += 2 * player_data["player_level"]
		
		
