extends Control

func _ready():
	battle_preparation("dungeon_1", "Slime")

func battle_preparation(dungeon_name: String, monster_name: String):
	var monster_stats = DungeonData.get_monster_stats(dungeon_name, monster_name)
	var player_stats = PlayerData.get_player_stats()
	
	$BattleZone/PlayerPanel/PlayerName.text = PlayerData.player_data["player_name"]
	$BattleZone/MonsterPanel/MonsterName.text = monster_name.capitalize()
	
	var monster_health = monster_stats["Health"]
	var monster_attack = monster_stats["Attack"]
	var monster_defense = monster_stats["Defense"]
	
	var player_health = player_stats["Health"]
	var player_attack = player_stats["Attack"]
	var player_defense = player_stats["Defense"]
	
	var player_text = "Health : " + str(player_health) + "\n"
	player_text += "Defense : " + str(player_defense) + "\n"
	player_text += "Attack : " + str(player_attack) + "\n"
	
	var monster_text = "Health : " + str(monster_health) + "\n"
	monster_text += "Defense : " + str(monster_defense) + "\n"
	monster_text += "Attack : " + str(monster_attack) + "\n"
	
	$BattleZone/PlayerPanel/PlayerStatsPanel/PlayerStats.text = player_text
	$BattleZone/MonsterPanel/MonsterStatsPanel/MonsterStats.text = monster_text
	
	print("Monster Stats : " + str(monster_stats) + "\nPlayer Stats : " + str(player_stats))
func battle_progress():
	pass

func battle_result():
	pass
