extends VBoxContainer

@onready var focus = $Control_Timer

var minute: bool = true #change to setting
var working: bool = true

func _ready():
	signals.connect("select_set", update_selected)

func update_selected():
	pass