extends VBoxContainer

@onready var title: Button = $HBox_Title/Button_Title

@onready var dynamic: Button = $HBox_Settings/Button_Dynamic
@onready var work: Button = $HBox_Settings/Button_Work
@onready var rest: Button = $HBox_Settings/Button_Rest

@onready var base_work: Label = $HBox_Details/Label_Work
@onready var base_rest: Label = $HBox_Details/Label_Rest
@onready var pomos: Label = $HBox_Details/Label_Pomo
@onready var base_long: Label = $HBox_Details/Label_Long

@onready var stop: Button = $HBox_Actions/Button_Stop
@onready var rest_time: Label = $HBox_Actions/Label_Rest
@onready var on: CheckButton = $HBox_Actions/Check_Work
@onready var work_time: Label = $HBox_Actions/Label_Work
@onready var play: Button = $HBox_Actions/Button_Play

@onready var code_obj : Control = $"../../"

var max_pomo: int
var play_image: Texture2D = load("res://assets/play-200xx.png")
var pause_image: Texture2D = load("res://assets/pause-200xx.png")
var stop_image: Texture2D = load("res://assets/stop-200xx.png")

func _ready():
	code_obj.connect("populate_ui", populate_ui)
	code_obj.connect("update_work", update_work)
	code_obj.connect("update_rest", update_rest)
	code_obj.connect("update_pomos", update_pomos)
	code_obj.connect("play_button", play_button)

func populate_ui(pomo):
	max_pomo = pomo["base_pomo"]
	
	title.text = pomo["title"]
	dynamic.disabled = not pomo["dynamic"]
	work.disabled = not pomo["auto_work"]
	rest.disabled = not pomo["auto_rest"]
	toolbox.update_text(base_work, 0, pomo["base_work"])
	toolbox.update_text(base_rest, 0, pomo["auto_rest"])
	toolbox.update_text(pomos, 1, pomo["pomo"], max_pomo)
	toolbox.update_text(base_long, 0, pomo["base_long"])
	toolbox.update_text(work_time, 2, pomo["work"][0],pomo["work"][1])
	toolbox.update_text(rest_time, 2, pomo["rest"][0], pomo["rest"][1])

func update_work(new_work: Array):
	toolbox.update_text(work_time, 2, new_work[0], new_work[1])

func update_rest(new_rest: Array):
	toolbox.update_text(rest_time, 2, new_rest[0], new_rest[1])

func update_pomos(current: int):
	toolbox.update_text(pomos, 1, current, max_pomo)

func play_button(running: bool, empty: bool, working: bool):
	play.icon = pause_image if running else play_image
	play.disabled = true if empty and not running else false 
	on.button_pressed = true if working else false
