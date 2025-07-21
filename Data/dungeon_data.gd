extends Node

var dungeon_data = {
	"dungeon_1": {
			"monster_list": {
				"Slime": {
					"stats": {
						"Health": 100
					},
					"drop_list": {
						"Gold": randf_range(1.0, 10.0),
						"Exp": randf_range(2.0, 5.0)
					},
				},
				"Giant_Slime": {
					"Health": 200,
				}
			},
			"environment_list": {
				"Stone": {
					"drop_list": {
						"Rock": randi_range(1, 5),
						"Flint": randi_range(0, 3),
						"Iron": randi_range(0, 1)
					},
				},
				"Tree" : {
					"drop_list": {
						"Leaf": randi_range(3, 6),
						"Stick": randi_range(1, 3),
						"Wood": randi_range(3, 9)
					},
				},
			}
		},
	"dungeon_2": {
		"monster_list": {
			
		}
	}
}
