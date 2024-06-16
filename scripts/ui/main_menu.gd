extends HBoxContainer

var pc: PackedScene
var mini_mode: PackedScene

var panel_tools: Panel
var panel_timers: Panel

func _ready():
	pc = load("res://scenes/mode/pc.tscn")
	mini_mode = load("res://scenes/mode/mini.tscn")
	if get_tree().current_scene.name == "Control_Pc":
		panel_timers = get_node("../../../Panel_Timers")
		panel_tools = get_node("../../../Panel_Tools")

func _on_check_mute_toggled(toggled_on:bool):
	global.mute = toggled_on
	signals.update_focus.emit(true)


func _on_check_tools_toggled(toggled_on):
	if toggled_on:
		panel_tools.show()
	else:
		panel_tools.hide()

func _on_check_timers_toggled(toggled_on):
	if toggled_on:
		panel_timers.show()
	else:
		panel_timers.hide()

func _on_option_button_item_selected(index):

	match index:
		0:
			if get_tree().current_scene != pc:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
				get_tree().change_scene_to_packed(pc)
		1:
			if get_tree().current_scene != pc:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				get_tree().change_scene_to_packed(pc)
		4: 
			if get_tree().current_scene != mini_mode:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				mini_size()
				

func mini_size():
	get_tree().change_scene_to_packed(mini_mode)
	DisplayServer.window_set_size(Vector2i(500,500))
	ProjectSettings.save()
