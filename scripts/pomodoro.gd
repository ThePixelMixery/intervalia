extends Control


signal populate_ui(pomo_data: Dictionary)
signal update_now_work (work_time: Array)
signal update_now_rest (rest_time: Array)
signal update_pomos (pomos: int)
signal play_button (running: bool, empty: bool)

func signal_buffer():
    pass

var title: String

var dynamic: bool
var auto_work: bool
var auto_rest: bool

var base_work: int
var base_rest: int
var ratio: float
var base_pomo: int
var base_long: int

var work_time: Array
var pomo_count: int
var rest_time: Array

var working: bool
var running: bool
var empty: bool

var pomo_data: Dictionary

func _ready():
    default_pomo()
    pack_data()
    populate_ui.emit(pomo_data)

func pack_data():
    ratio = float(base_work)/float(base_rest)
    pomo_data = {
        title = title,
        dynamic = dynamic,
        auto_work = auto_work,
        auto_rest = auto_rest,
        base_work = base_work,
        base_rest = base_rest,
        ratio = ratio,
        base_pomo = base_pomo,
        base_long = base_long,
        work_time = work_time,
        pomo_count = pomo_count,
        rest_time = rest_time,
    }

func unpack_data(pomo:Dictionary):
    title = pomo["title"]
    dynamic = pomo["dynamic"]
    auto_work = pomo["auto_work"]
    auto_rest = pomo["auto_rest"]
    base_work = pomo["base_work"]
    base_rest = pomo["base_rest"]
    base_pomo = pomo["base_pomo"]
    base_long = pomo["base_long"]
    work_time = pomo["work_time"]
    pomo_count = pomo["pomo_count"]
    rest_time = pomo["rest_time"]
    ratio = float(base_work)/float(base_rest)
    
func default_pomo():
    title = " Default"
    dynamic = false
    auto_work = true
    auto_rest = true
    base_work = 25
    base_rest = 5
    ratio = float(base_work)/float(base_rest)
    base_pomo = 4
    base_long = 15
    work_time = [25,0]
    pomo_count = 0
    rest_time = [0,0]
    selected.pomo_node = self

func reset_variable(variable:String):
    match variable:
        "all":
            work_time = [base_work,0]
            update_now_work.emit(work_time)
            rest_time = [base_rest,0]
            update_now_rest.emit(work_time)
            pomo_count = 0
            update_pomos.emit(work_time)
            running = false
            play_button.emit(false)

func _on_button_stop_pressed():
    reset_variable("all")

func _on_button_play_toggled(toggled_on:bool):
    running = toggled_on
    play_button.emit(running, empty)