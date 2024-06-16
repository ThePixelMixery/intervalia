extends VBoxContainer

@onready var title = $HBox_Title/Label_Title

var editor_scene = preload("res://scenes/windows/edit_window.tscn")

func _ready():
	signals.connect("open_editor", open_editor)
	signals.connect("select_set", update_selection)

func open_editor():
	global.selected._on_button_stop_pressed()
	add_child(editor_scene.instantiate())

func _on_button_edit_pressed():
	var confirm_data = [
		self,
		editor_scene,
		"edit_pomo",
		"About Editing Timers",
		"Editting the pomodoro will reset it, are you sure you want to continue?",
		"Reset",
		"Empty dynamic break bank first"
	]

	var confirm_instance = confirm.instantiate(confirm_data)
	add_child(confirm_instance)

func _on_button_add_pressed():
	var instance = editor_scene.instantiate()
	instance.connect("new_timer", add_timer)
	add_child(instance)

func update_selection():
	title.text = "Selected: \n %s" %global.selected.title

func add_timer():
	print("timer was made")
