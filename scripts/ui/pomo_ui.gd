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
    code_obj.connect("update_now_work", update_work)
    code_obj.connect("update_now_rest", update_rest)
    code_obj.connect("update_pomos", update_pomos)
    code_obj.connect("play_button", play_button)

func update_text(object:Node, num1: int, num2: int = 0):
    match object:
        base_work:
            base_work.text = '%d' % num1
        base_rest:
            base_rest.text = '%d' % num1
        pomos:
            pomos.text =  '%d/%d' % [num1, max_pomo]
        base_long:
            base_long.text = '%d' % num1
        work_time:
            work_time.text = '%02d:%02d' % [num1, num2]
        rest_time:
            rest_time.text = '%02d:%02d' % [num1, num2]

func populate_ui(pomo):
    title.text = pomo["title"]
    dynamic.disabled = not pomo["dynamic"]
    work.disabled = not pomo["auto_work"]
    rest.disabled = not pomo["auto_rest"]
    update_text(base_work, pomo["base_work"])
    update_text(base_rest, pomo["auto_rest"])
    max_pomo = pomo["base_pomo"]
    update_text(pomos,pomo["pomo_count"])
    update_text(base_long, pomo["base_long"])
    update_text(work_time, pomo["work_time"][0],pomo["work_time"][1])
    update_text(rest_time, pomo["rest_time"][0], pomo["rest_time"][1])

func update_work(minute: int, second: int):
    update_text(work_time, minute, second)

func update_rest(minute: int, second: int):
    update_text(rest_time, minute, second)

func update_pomos(current: int):
    update_text(pomos, current)

func play_button(running: bool, empty: bool):
    play.icon = pause_image if running else play_image
    play.disabled = empty
        