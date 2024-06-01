extends VBoxContainer

var editor = preload("res://scenes/edit_window.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_button_pressed():
	var edit_instance = editor.instantiate()
	add_child(edit_instance)
