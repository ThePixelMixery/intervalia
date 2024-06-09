extends VBoxContainer

var editor = preload("res://scenes/edit_window.tscn")


func _ready():
	signals.connect("open_editor", open_editor)

func _on_button_pressed():
	var confirm_data = [
		self,
		editor,
		"edit_pomo",
		"About Editing Timers",
		"Editting the pomodoro will reset it, are you sure you want to continue?",
		" Empty break bank first "
	]

	var confirm_instance = confirm.instantiate(confirm_data)
	add_child(confirm_instance)

func open_editor():
	selected.pomo_node._on_button_stop_pressed()
	add_child(editor.instantiate())
