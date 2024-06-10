extends HSplitContainer

@onready var mute_button = $VBox_Main/HBox_Menu/Button_Mute

var mute_image: Texture2D = load("res://assets/image/mute-200xx.png")
var unmute_image: Texture2D = load("res://assets/image/unmute-200xx.png")

func _on_check_button_toggled(toggled_on:bool):
	collapsed = not toggled_on

func _on_button_meeting_toggled(toggled_on:bool):
	toolbox.mute = toggled_on
	if toggled_on:
		mute_button.icon = mute_image
	else:
		mute_button.icon = unmute_image
