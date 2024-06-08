extends Node

@onready var printer: VBoxContainer = get_node("../Control_Buffer/VBox_Notifications")

var mute: bool
var max_notif: int = 10

func update_text(node: Node, type: int, num1: int, num2: int = 0):
	match type:
		0: #simple
			node.text = '%d' % num1
		1: #pomodoro
			node.text =  '%d/%d' % [num1, num2]
		2: #time
			node.text = '%02d:%02d' % [num1, num2]

func pront(text: String):
	var new_label = Label.new()
	new_label.text = text
	printer.add_child(new_label)
	while printer.get_child_count() > max_notif:
		printer.get_child(0).free()
