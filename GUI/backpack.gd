extends Control

var player_backpack = PlayerData.player_data["player_backpack"]

func _ready():
	show_items()

func show_items():
	var backpack_text = "Items \n\n"
	for items in player_backpack.keys():
		var quantity = player_backpack[items]
		backpack_text += items + " : " + str(quantity) + "\n"
	$BackpackPanel/BackpackLabel.text = backpack_text
