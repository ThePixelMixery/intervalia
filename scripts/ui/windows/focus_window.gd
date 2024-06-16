extends VBoxContainer

@onready var progress_pomo = $Prog_Pomo
@onready var progress_min = $Prog_Minute

@onready var focus = $Control_Selected

var minute: bool = true #change to setting
var working: bool = true

func _ready():
	signals.connect("select_set", update_selected)

func update_selected():
	pass