extends Window

var minutes: Array = [0,0]

signal add_minutes(minutes: int)

func _on_spin_box_minutes_value_changed(value:int):
	minutes[0] = value

func _on_button_cancel_pressed():
	queue_free()

func _on_button_accept_pressed():
	add_minutes.emit(minutes)
	queue_free()

func _on_close_requested():
	queue_free()
