extends VBoxContainer

@onready var title: TextEdit = $Grid_Number/TextEdit_Title
@onready var work: SpinBox = $Grid_Number/SpinBox_Work
@onready var rest: SpinBox = $Grid_Number/SpinBox_Rest
@onready var pomos: SpinBox = $Grid_Number/SpinBox_Pomo
@onready var long: SpinBox = $Grid_Number/SpinBox_Long
@onready var dynamic: CheckButton = $Grid_Check/Check_Dynamic
@onready var autowork: CheckButton = $Grid_Check/Check_AutoWork
@onready var autorest: CheckButton = $Grid_Check/Check_AutoRest

@onready var display_title: Button = $VBox_Pomo/HBox_Title/Button_Title
@onready var display_dynamic: Button = $VBox_Pomo/HBox_Settings/Button_Dynamic
@onready var display_autoWork: Button = $VBox_Pomo/HBox_Settings/Button_Work
@onready var display_autoRest: Button = $VBox_Pomo/HBox_Settings/Button_Rest
@onready var display_work: Label = $VBox_Pomo/HBox_Details/Label_Work
@onready var display_rest: Label = $VBox_Pomo/HBox_Details/Label_Rest
@onready var display_pomo: Label = $VBox_Pomo/HBox_Details/Label_Pomo
@onready var display_long: Label = $VBox_Pomo/HBox_Details/Label_Long

func _ready():
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title
	title.placeholder_text = selected.pomo_node.title

func _on_window_close_requested():
	queue_free()
