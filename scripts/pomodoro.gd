extends Control

func signal_buffer():
    pass

var title: String

var dynamic: bool
var auto_work: bool
var auto_rest: bool

var base_rest: int
var base_long: int
var ratio: float
var base_pomo: int
var base_work: int

var work: Array
var pomo: int
var rest: Array

var working: bool = true
var running: bool
var empty: bool
var queue_stop: bool

var pomo_data: Dictionary

@onready var ui = $Margin/VBox_Pomo
@onready var timer = $Timer
@onready var add_window = preload("res://scenes/add_time.tscn")

func _ready():
    default_pomo()
    populate()

func populate():
    pack_data()
    ui.populate_ui(pomo_data)

func pack_data():
    ratio = float(base_rest)/float(base_work)
    if dynamic:
        rest = [0,0]
        empty = true

    pomo_data = {
        title = title,
        dynamic = dynamic,
        auto_work = auto_work,
        auto_rest = auto_rest,
        base_rest = base_rest,
        base_long = base_long,
        base_pomo = base_pomo,
        base_work = base_work,
        work = work,
        pomo = pomo,
        rest = rest,
    }

func unpack_data(data:Dictionary):
    title = data["title"]
    dynamic = data["dynamic"]
    auto_work = data["auto_work"]
    auto_rest = data["auto_rest"]
    base_rest = data["base_rest"]
    base_long = data["base_long"]
    base_pomo = data["base_pomo"]
    base_work = data["base_work"]
    rest = data["rest"]
    pomo = data["pomo"]
    work = data["work"]
    
func default_pomo():
    title = "Default"
    dynamic = true
    auto_work = true
    auto_rest = true
    #base_work = 25
    base_rest = 15
    base_long = 30
    base_pomo = 1
    base_work = 5
    #work = [25,0]
    rest = [0,0]
    pomo = 0
    #rest = [0,0]
    work = [0,3]
    selected.pomo_node = self

func reset_variable(variable:String):
    match variable:
        "all":
            work = [base_work,0]
            rest = [base_rest,0]
            pomo = 0
            running = false
    populate()

func _on_button_stop_pressed():
    toolbox.pront("stopped")
    reset_variable("all")
    running = false
    timer.stop()
    update_controls()

func update_controls():
    ui.play_button(running)
    ui.switch_button(working, empty)

func _on_button_play_toggled(toggled_on:bool):
    running = toggled_on
    toolbox.pront("running timer command")
    update_controls()
    if running == true:
        run_timer()

func _on_check_work_toggled(toggled_on:bool):
    working = toggled_on
    update_controls()

func _on_button_add_pressed():
    var add_instance = add_window.instantiate()
    add_instance.connect("add_minutes", add_work_minutes)
    add_child(add_instance)

func add_work_minutes(minutes: int):
    toolbox.pront("minutes to add: " )
####### HERE #######

func run_timer():
    if running:
        toolbox.pront("starting timer")
        timer.start()
    else:
        toolbox.pront("stoping timer")
        timer.stop()
    
func _on_timer_timeout():
    if working:
        toolbox.pront("doing work time updates")
        running_work()
    elif empty and not working:
        timer.stop()
        ui.play_button(running)
    else:
        toolbox.pront("doing rest time updates")
        running_rest()

func running_work():
    work[1] -= 1
    if dynamic:
        add_to_rest()
    if work [0] <= 0 and work [1] <= 0:
        timeout()
    elif work[1] == -1:
        work[0] -= 1
        work[1] = 59
    ui.update_work(work)

func running_rest():
    rest[1] -= 1
    if rest[0] <= 0 and rest[1] <= 0:
        empty = true
        timeout()
    elif rest[1] == -1:
        rest[0] -= 1
        rest[1] = 59
    ui.update_rest(rest)

func timeout():
    if working:
        toolbox.pront ("timed out working")
        working = false if auto_rest else true
        running = true if auto_rest else false
        iterate_pomo()
        work[0] = base_work
        ui.update_pomos(pomo)
        ui.play_button(running)
        
    else:
        if not dynamic:
            rest[0] = base_rest
        toolbox.pront ("timed out resting")
        toolbox.pront("rest time is empty")
        working = true if auto_work else false
        running = true if auto_work else false
        if queue_stop:
            signals.open_editor.emit()
        
    ui.play_button(running)
    ui.switch_button(working, empty)
    run_timer()

func iterate_pomo():
    pomo += 1
    if pomo > base_pomo:
        rest[0] += (base_long - base_rest)
        pomo = 0

func add_to_rest():
    empty = false
    rest[1] += 1 * ratio
    if rest[1] > 59:
        rest[0] += 1
        rest[1] -= 59
    ui.update_rest(rest)

