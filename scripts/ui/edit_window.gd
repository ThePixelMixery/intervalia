extends VBoxContainer

@onready var title:TextEdit = $Grid_Number/TextEdit_Title
@onready var work: SpinBox = $Grid_Number/SpinBox_Work
@onready var rest = $Grid_Number/SpinBox_Rest
@onready var pomos = $Grid_Number/SpinBox_Pomo
@onready var long = $Grid_Number/SpinBox_Long
@onready var dynamic = $Grid_Check/Check_Dynamic
@onready var autowork = $Grid_Check/Check_AutoWork
@onready var autorest = $Grid_Check/Check_AutoRest

func load():
	pass

func _ready():
	pass

func _on_window_close_requested():
	queue_free()
