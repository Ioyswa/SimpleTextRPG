extends Node

var dungeon_data = {
	"dungeon_1": {
		"monster_list": {
			"Slime": {
				"stats": {
					"Health": 100,
					"Attack": 50,
					"Defense": 50
				},
				"drop_list": {
					"Gold": {
						"min": 1.0,
						"max": 10.0,
						"chance": 100
					},
					"Exp": {
						"min": 2.0,
						"max": 5.0,
						"chance": 100
					},
					"Slime_Soul": {
						"min": 1,
						"max": 2,
						"chance": 50
					}
				},
			},
			"Giant_Slime": {
				"stats": {
					"Health": 200,
					"Attack": 100,
					"Defense": 50
				},
				"drop_list": {
					"Gold": {
						"min": 5.0,
						"max": 20.0,
						"chance": 100
					},
					"Exp": {
						"min": 5.0,
						"max": 15.0,
						"chance": 100
					},
					"Giant_Slime_Core": {
						"min": 1,
						"max": 2,
						"chance": 20
					}
				},
			}
		},
		"env_list": {
			"Stone": {
				"drop_list": {
					"Rock": {
						"min": 1,
						"max": 5,
						"chance": 100
					},
					"Flint": {
						"min": 1,
						"max": 5,
						"chance": 100
					},
					"Iron": {
						"min": 1,
						"max": 5,
						"chance": 100
					}
				},
			},
			"Tree" : {
				"drop_list": {
					"Leaf": {
						"min": 1,
						"max": 5,
						"chance": 100
					},
					"Stick": {
						"min": 1,
						"max": 5,
						"chance": 100
					},
					"Wood": {
						"min": 1,
						"max": 5,
						"chance": 100
					}
				},
			},
		}
	},
	#"dungeon_2": {
		#"monster_list": {
			#
		#},
		#"env_list": {
			#
		#}
	#}
}

func _ready():
	get_monster_stats("dungeon_1", "Slime")

func get_drops(dungeon_name: String, obj_type: String, obj_name: String) -> Dictionary:
	var final_drops = {}
	var obj_data
	
	if obj_type == "monster":
		obj_data = dungeon_data[dungeon_name]["monster_list"][obj_name]
	elif obj_type == "env":
		obj_data = dungeon_data[dungeon_name]["env_list"][obj_name]
	else:
		return final_drops
		
	for drop_item in obj_data["drop_list"].keys():
		var drop_data = obj_data["drop_list"][drop_item]
		
		if randi_range(1, 100) <= drop_data["chance"]:
			var quantity
			if typeof(drop_data["min"]) == TYPE_FLOAT:
				quantity = snapped(randf_range(drop_data["min"], drop_data["max"]), 0.1)
			else:
				quantity = randi_range(drop_data["min"], drop_data["max"])
				
			final_drops[drop_item] = quantity
			
			
	return final_drops

func get_monster_stats(dungeon_name: String, monster_name: String) -> Dictionary:
	var monster = dungeon_data[dungeon_name]["monster_list"][monster_name]["stats"]
	return monster
	

func kill_monster(dungeon_name: String, monster_name: String) -> Dictionary:
	return get_drops(dungeon_name, "monster", monster_name)

func harvest_environment(dungeon_name: String, env_name: String) -> Dictionary:
	return get_drops(dungeon_name, "env", env_name)
