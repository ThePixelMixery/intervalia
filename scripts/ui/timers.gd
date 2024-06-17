extends VBoxContainer

@onready var title = $HBox_Title/Label_Title

var editor_scene = preload("res://scenes/windows/edit_window.tscn")
var editor_scene = preload("res://scenes/windows/edit_window.tscn")

func _ready():
	signals.connect("open_editor", open_editor)
	signals.connect("select_set", update_selection)
	signals.connect("new_timer", add_timer)

func open_editor():
	global.selected._on_button_stop_pressed()
	add_child(editor_scene.instantiate())

func _on_button_edit_pressed():
	var confirm_data = [
		self,
		editor_scene,
		"edit_pomo",
		null,
		"About Editing Timers",
		"Editting the pomodoro will reset it, are you sure you want to continue?",
		"Reset",
		"Empty dynamic break bank first"
	]
	var confirm_instance = confirm.instantiate(confirm_data)
	add_child(confirm_instance)

func _on_button_add_pressed():
	var confirm_data = [
		self,
		editor_scene,
		"add_pomo",
		"Add timer or category?",
		"Would you like to add a category to put timers into or add a timer to a category?",
		"Add a category",
		"Add a timer to an existing category"
	]
	var confirm_instance = confirm.instantiate(confirm_data)
	add_child(confirm_instance)

func update_selection():
	title.text = "Selected: \n %s" %global.selected.title

func add_timer(new_pomo: Dictionary):
	print("timer was made")
