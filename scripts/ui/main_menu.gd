extends HBoxContainer

var editor = preload("res://scenes/windows/edit_window.tscn")
@onready var panel_tools = $"../../HBox_Main/Panel_Tools"
@onready var panel_timers = $"../../HBox_Main/Panel_Timers"

func _ready():
	signals.connect("open_editor", open_editor)

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
