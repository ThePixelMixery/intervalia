extends Window

class_name confirm

var parent_node: Node
var packed_scene: PackedScene
var type: String
var title_text: String
var mess_text: String
var accept_text: String
var other_text: String

var skip: bool
var unpacked_instance: Node

static func instantiate(confirm_data:Array): 
	var instance = load('res://scenes/windows/confirm_window.tscn').instantiate()
	instance.parent_node = confirm_data[0]
	instance.packed_scene = confirm_data[1]
	instance.type = confirm_data [2]
	instance.title_text = confirm_data[3]
	instance.mess_text = confirm_data[4]
	instance.accept_text = confirm_data[5]
	instance.other_text = confirm_data[6]
	return instance

func _ready():
	var message: Label = get_node("Margin/VBox_Text/Label_Message")
	var other: Button = get_node("Margin/VBox_Text/Button_Other")
	var accept: Button = get_node("Margin/VBox_Text/HBox_Actions/Button_Accept")
	title = title_text
	message.text = mess_text
	accept.text = accept_text
	other.text = other_text
	skip = settings.skip_check[type]
	unpacked_instance = packed_scene.instantiate()
	if skip:
		confirmed()

func close():
	queue_free()

func confirmed():
	global.selected._on_button_stop_pressed()
	parent_node.add_child(unpacked_instance)
	close()

func _on_button_cancel_pressed():
	close()

func _on_button_accept_pressed():
	confirmed()

func _on_check_skip_toggled(toggled_on:bool):
	skip = toggled_on
	settings.skip_check[type] = toggled_on

func _on_close_requested():
	close()

func _on_button_other_pressed():
	match type:
		"edit_pomo":
			unpacked_instance.focus = true
			if global.selected.dynamic == true and global.selected.empty != true:
				global.selected.queue_stop = true 
				if global.selected.working:
					global.selected.working = false
					global.selected.ui.switch_button(false, false)
				if global.selected.running == false:
					global.selected._on_button_play_toggled(true)
				global.selected.working = false
			else:
				confirmed()
	close()
