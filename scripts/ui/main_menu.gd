extends HBoxContainer


var editor = preload("res://scenes/windows/edit_window.tscn")
var pc: PackedScene
var mini_mode: PackedScene

var panel_tools: Panel
var panel_timers: Panel

func _ready():
	signals.connect("open_editor", open_editor)
	pc = load("res://scenes/mode/pc.tscn")
	mini_mode = load("res://scenes/mode/mini.tscn")
	if get_tree().current_scene.name == "Control_Pc":
		panel_timers = get_node("../../../Panel_Timers")
		panel_tools = get_node("../../../Panel_Tools")

func _on_check_mute_toggled(toggled_on:bool):
	global.mute = toggled_on
	signals.update_focus.emit(true)

func open_editor():
	global.pomo_node._on_button_stop_pressed()
	add_child(editor.instantiate())

func _on_button_edit_pressed():
	var confirm_data = [
		self,
		editor,
		"edit_pomo",
		"About Editing Timers",
		"Editting the pomodoro will reset it, are you sure you want to continue?",
		"Reset",
		"Empty dynamic break bank first"
	]

	var confirm_instance = confirm.instantiate(confirm_data)
	add_child(confirm_instance)

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
