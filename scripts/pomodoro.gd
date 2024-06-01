extends Control


signal populate_ui(pomo_data: Dictionary)
signal update_work (work: Array)
signal update_rest (rest: Array)
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

var work: Array
var pomo: int
var rest: Array

var working: bool = true
var running: bool
var empty: bool

var pomo_data: Dictionary

@onready var timer = $Timer

func _ready():
    default_pomo()
    populate()

func populate():
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
        work = work,
        pomo = pomo,
        rest = rest,
    }

func unpack_data(data:Dictionary):
    title = data["title"]
    dynamic = data["dynamic"]
    auto_work = data["auto_work"]
    auto_rest = data["auto_rest"]
    base_work = data["base_work"]
    base_rest = data["base_rest"]
    base_pomo = data["base_pomo"]
    base_long = data["base_long"]
    work = data["work"]
    pomo = data["pomo"]
    rest = data["rest"]
    ratio = float(base_work)/float(base_rest)
    
func default_pomo():
    title = " Default"
    dynamic = false
    auto_work = true
    auto_rest = true
    #base_work = 25
    base_work = 1
    base_rest = 5
    ratio = float(base_work)/float(base_rest)
    base_pomo = 4
    base_long = 15
    #work = [25,0]
    work = [0,3]
    pomo = 0
    rest = [0,0]
    selected.pomo_node = self

func reset_variable(variable:String):
    match variable:
        "all":
            work = [base_work,0]
            update_work.emit(work)
            rest = [base_rest,0]
            update_rest.emit(work)
            pomo = 0
            update_pomos.emit(work)
            running = false
            play_button.emit(false)

func _on_button_stop_pressed():
    reset_variable("all")
    timer.stop()

func _on_button_play_toggled(toggled_on:bool):
    running = toggled_on
    
    play_button.emit(running, empty)
    print("running timer command")
    run_timer()

func run_timer():
    if running:
        print("starting timer")
        timer.start()
    else:
        print("stoping timer")
        timer.stop()

func _on_timer_timeout():
    if working:
        print("doing work time updates")
        running_work()
    elif empty:
        print("rest time is empty")
        pass
    else:
        print("beep boop")
        pass

func running_work():
    work[1] -= 1
    if dynamic:
        add_to_rest()
    if work [0] <= 0 and work [1] <= 0:
        timeout()
    elif work[1] == -1:
        work[0] -= 1
        work[1] = 59
    update_work.emit(work)
    
func timeout():
    if working:
        print ("timed out working")
        working = false
        running = false
        run_timer()
        pomo += 1
        update_pomos.emit(pomo)
        play_button.emit(running,empty)

func add_to_rest():
    pass