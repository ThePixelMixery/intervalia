extends Window

var minutes: Array = [0,0]
var work: bool = true

signal add_minutes(work: bool, minutes: Array)

func _on_spin_box_minutes_value_changed(value:int):
	minutes[0] = value

func _on_check_button_toggled(toggled_on):
	work = toggled_on

func _on_button_accept_pressed():
	add_minutes.emit(work, minutes)
	queue_free()

func _on_button_cancel_pressed():
	queue_free()


func _on_close_requested():
	queue_free()


