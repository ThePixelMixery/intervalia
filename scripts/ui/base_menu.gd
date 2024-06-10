extends HSplitContainer

var editor = preload("res://scenes/windows/edit_window.tscn")

func _ready():
	signals.connect("open_editor", open_editor)

func _on_check_button_toggled(toggled_on:bool):
	collapsed = not toggled_on

func _on_check_mute_toggled(toggled_on:bool):
	toolbox.mute = toggled_on

func open_editor():
	selected.pomo_node._on_button_stop_pressed()
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



