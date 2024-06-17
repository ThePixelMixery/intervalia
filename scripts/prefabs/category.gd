extends VBoxContainer

class_name category

@onready var title: Label = $Label_Title

static func instantiate(category: String, timers: Array):
	var instance = load("res://scenes/prefabs/timer_category.tscn")
	instance.title.text = category
	return instance
