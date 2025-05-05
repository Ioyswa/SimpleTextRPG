extends Control

@onready var save_slot = $CanvasLayer/Panel/GridContainer
@onready var line_edit = $CanvasLayer/EnterName/LineEdit
@onready var enter_name_panel = $CanvasLayer/EnterName


var save_buttons = []
var save_buttons_count := 0
var current_save_slot = -1
var active_save_slot = -1

var player_data = {}

func _ready():
	PlayerData.player_data = {}
	for i in range(3):
		var save_button = Button.new()
		save_slot.add_child(save_button)

		var data = load_data(i)
		if data:
			save_buttons_count += 1
			save_button.add_theme_font_size_override("font_size", 58)
			save_button.text = data["player_name"]
			save_button.pressed.connect(load_existing_data.bind(data, i))
		else:
			save_button.text = "  +  "
			save_button.add_theme_font_size_override("font_size", 128)
			save_button.pressed.connect(create_new_save.bind(i))
		save_buttons.append(save_button)
	
	for x in range(save_buttons_count):
		var delete_button = Button.new()
		save_slot.add_child(delete_button)
		delete_button.add_theme_font_size_override("font_size", 16)
		delete_button.text = " Delete "
		delete_button.pressed.connect(delete_data.bind(x))


	enter_name_panel.hide()


func create_new_save(save_slot):
	print(save_slot)
	current_save_slot = save_slot
	$CanvasLayer/Panel.hide()
	$CanvasLayer/EnterName.show()
	line_edit.grab_focus()
	line_edit.text_submitted.connect(set_player_name)


func set_player_name(new_text):
	line_edit.clear()
	if new_text.strip_edges() != "":
		PlayerData.player_data["player_name"] = new_text
		PlayerData.player_data["save_slot"] = current_save_slot
		print(current_save_slot, PlayerData.player_data)
		save_data(current_save_slot, PlayerData.player_data)
		get_tree().change_scene_to_file("res://class_selection.tscn")
		#enter_name_panel.hide()
		#$CanvasLayer/Panel.show()
		#update()
		

func save_data(save_slot: int, save_data: Dictionary):
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_data = JSON.stringify(save_data)
	file.store_string(json_data)
	file.close()

func load_data(save_slot: int) -> Dictionary:
	var path = "user://test_save" + str(save_slot) + ".json"
	var file = FileAccess.open(path, FileAccess.READ)
	#print(file)
	if file != null:
		var json_data = file.get_as_text()
		var parse_result = JSON.parse_string(json_data)
		if parse_result != {}:
			file.close()
			return parse_result
		file.close()
		return {}
	return {}

func load_existing_data(data: Dictionary, save_slot: int):
	PlayerData.player_data = data
	get_tree().change_scene_to_file("res://Scene/main.tscn")
	
	
func delete_data(save_slot: int):
	var path = "user://test_save" + str(save_slot) + ".json"
	DirAccess.remove_absolute(path)
	update()

func update():
	get_tree().reload_current_scene()
