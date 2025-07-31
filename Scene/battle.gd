extends Control

var monster_stats
var player_stats

var current_monster_health
var current_monster_attack
var current_monster_defense

var current_player_health
var current_player_attack
var current_player_defense

func _ready():
	battle_preparation("dungeon_1", "Slime")

func battle_preparation(dungeon_name: String, monster_name: String):
	monster_stats = DungeonData.get_monster_stats(dungeon_name, monster_name)
	player_stats = PlayerData.get_player_stats()
	
	$BattleZone/PlayerPanel/PlayerName.text = PlayerData.player_data["player_name"]
	$BattleZone/MonsterPanel/MonsterName.text = monster_name.capitalize()
	
	current_monster_health = monster_stats["Health"]
	current_monster_attack = monster_stats["Attack"]
	current_monster_defense = monster_stats["Defense"]

	current_player_health = player_stats["Health"]
	current_player_attack = player_stats["Attack"]
	current_player_defense = player_stats["Defense"]
	
	var player_text = "Health : " + str(current_player_health) + "\n"
	player_text += "Defense : " + str(current_player_defense) + "\n"
	player_text += "Attack : " + str(current_player_attack) + "\n"
	
	var monster_text = "Health : " + str(current_monster_health) + "\n"
	monster_text += "Defense : " + str(current_monster_defense) + "\n"
	monster_text += "Attack : " + str(current_monster_attack) + "\n"
	
	$BattleZone/PlayerPanel/PlayerStatsPanel/PlayerStats.text = player_text
	$BattleZone/MonsterPanel/MonsterStatsPanel/MonsterStats.text = monster_text
	
	battle_progress(dungeon_name, monster_name)
	
	print("Monster Stats : " + str(monster_stats) + "\nPlayer Stats : " + str(player_stats))
	
func update_battle_ui():
	if current_player_health < 0:
		current_player_health = 0.0
	
	if current_monster_health < 0:
		current_monster_health = 0.0
	
	var player_text = "Health : " + str(current_player_health) + "\n"
	player_text += "Defense : " + str(current_player_defense) + "\n"
	player_text += "Attack : " + str(current_player_attack) + "\n"
	
	var monster_text = "Health : " + str(current_monster_health) + "\n"
	monster_text += "Defense : " + str(current_monster_defense) + "\n"
	monster_text += "Attack : " + str(current_monster_attack) + "\n"
	
	$BattleZone/PlayerPanel/PlayerStatsPanel/PlayerStats.text = player_text
	$BattleZone/MonsterPanel/MonsterStatsPanel/MonsterStats.text = monster_text


func battle_progress(dungeon_name: String, monster_name: String):
	var monster_defense_reduction = min(0.9, current_monster_defense / 100.0)
	var player_defense_reduction = min(0.9, current_player_defense / 100.0)
	print(player_defense_reduction)
	while current_monster_health >= 0 and current_player_health >= 0:
		if current_player_health > 0 and current_monster_health > 0:
			var damage_to_monster = current_player_attack * (1.0 - monster_defense_reduction)
			current_monster_health -= damage_to_monster
			update_battle_ui()
	
		await get_tree().create_timer(0.5).timeout
		if current_monster_health > 0 and current_player_health > 0:
			var damage_to_player = current_monster_attack * (1.0 - player_defense_reduction)
			current_player_health -= damage_to_player
			update_battle_ui()
		
		if current_player_health <= 0:
			battle_result("Lose", dungeon_name, monster_name)
			update_battle_ui()
			break
		elif current_monster_health <= 0 and current_player_health <= 0:
			battle_result("Draw", dungeon_name, monster_name)
			update_battle_ui()
			break
		elif current_player_health >= 0:
			battle_result("Win", dungeon_name, monster_name)
			update_battle_ui()
			break

func battle_result(state: String, dungeon_name: String, monster_name: String):
	var battle_result = {}
	battle_result["state"] = state
	battle_result["dungeon_name"] = dungeon_name
	battle_result["monster_name"] = monster_name
	BattleData.battle_end.emit(state, dungeon_name, monster_name)
	
