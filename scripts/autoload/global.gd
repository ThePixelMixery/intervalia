extends Node

var printer: VBoxContainer

var selected: Control
var mute: bool
var testing: bool
var max_notif: int = 10
var audio: Node

func _ready():
	signals.connect("new_scene", check_scene)
	check_scene(get_tree().current_scene.name)

func update_text(node: Node, type: int, num1: int, num2: int = 0):
	match type:
		0: #simple
			node.text = '%d' % num1
		1: #pomodoro
			node.text =  '%d/%d' % [num1, num2]
		2: #time
			node.text = '%02d:%02d' % [num1, num2]
		3: #mute
			node.text = '|%02d:%02d|' % [num1, num2]

func pront(text: String):
	if testing:
		var new_label = Label.new()
		new_label.text = text
		printer.add_child(new_label)
		while printer.get_child_count() > max_notif:
			printer.get_child(0).free()

func check_scene(scene_name: String):
	match scene_name:
		"Control_Pc":
			audio = get_node("/root/Control_Pc/Node_Audio")
			printer = get_node("/root/Control_Pc/VBox_Notifications")
		"Control_Mini":
			audio = get_node("/root/Control_Mini/Node_Audio")
			printer = get_node("/root/Control_Mini/VBox_Notifications")

func play_sound(selection: int, sound: Resource, play: bool = true):
	if not mute:
		# 0 is working background
		# 1 is resting background
		if audio.get_child(selection).stream != sound:
			audio.get_child(selection).stream = sound
		match selection:
			0 or 1:
				if play:
					audio.get_child(selection).play()
				else:
					audio.get_child(selection).stop()
			_:
				audio.get_child(selection).play()
