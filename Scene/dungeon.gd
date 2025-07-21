extends Control



func _on_button_pressed():
	var player_exp = PlayerData.player_data["Stats"]["Experience"]
	print(player_exp)
