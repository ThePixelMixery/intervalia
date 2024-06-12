extends Control

func signal_buffer():
	pass

var working: bool = true
var running: bool
var empty: bool
var queue_stop: bool
var spill: bool

var title: String

var auto_rest: bool
var mute: bool
var dynamic: bool
var auto_work: bool

var base_rest: int
var base_long: int
var ratio: float
var base_pomo: int
var base_work: int

var work: Array
var pomo: int
var rest: Array

var sound_work: String
var sound_rest: String
var sound_long: String
var audio_work: Resource
var audio_rest: Resource
var audio_long: Resource

var pomo_data: Dictionary

@onready var ui = $Margin/VBox_Pomo
@onready var timer = $Timer
@onready var add_window = preload("res://scenes/windows/add_time.tscn")

func _ready():
	default_pomo()
	populate()

func populate():
	pack_data()
	ui.populate_ui(pomo_data)

func pack_data():
	audio_work = load("res://assets/sound/work/" + sound_work + ".mp3")
	audio_rest = load("res://assets/sound/rest/" + sound_rest + ".mp3")
	audio_long = load("res://assets/sound/long/" + sound_long + ".mp3")

	ratio = float(base_rest)/float(base_work)
	if dynamic:
		rest = [0,0]
		empty = true
	pomo_data = {
		title = title,
		auto_rest = auto_rest,
		dynamic = dynamic,
		mute = mute,
		auto_work = auto_work,
		base_rest = base_rest,
		base_long = base_long,
		base_pomo = base_pomo,
		base_work = base_work,
		work = work,
		pomo = pomo,
		rest = rest,
		audio_work = audio_work,
		audio_rest = audio_rest,
		audio_long = audio_long
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
	sound_work = data["sound_work"]
	sound_rest = data["sound_rest"]
	sound_long = data["sound_long"]
	
func default_pomo():
	title = "Default"
	dynamic = true
	auto_rest = true
	mute = true
	auto_work = true
	#base_work = 25
	base_rest = 5
	base_long = 15
	base_pomo = 4
	base_work = 25
	rest = [0,0]
	pomo = 0
	work = [25,0]
	sound_work = "work-01"
	sound_rest = "rest-01"
	sound_long = "long-01"
	global.selected = self
	signals.select_set.emit()

func reset_variable(variable:String):
	match variable:
		"all":
			work = [base_work,0]
			rest = [base_rest,0]
			pomo = 0
			running = false
	populate()
	signals.select_set.emit()

func _on_button_stop_pressed():
	global.pront("stopped")
	reset_variable("all")
	running = false
	timer.stop()
	update_controls()

func update_controls():
	ui.play_button(running)
	ui.switch_button(working, empty)

func _on_button_play_toggled(toggled_on:bool):
	running = toggled_on
	update_controls()
	if running == true:
		run_timer()
	else:
		timer.stop()
		
func _on_check_work_toggled(toggled_on:bool):
	working = toggled_on
	update_controls()

func _on_button_add_pressed():
	var add_instance = add_window.instantiate()
	add_instance.connect("add_minutes", add_work_time)
	add_child(add_instance)

func add_work_time(time:Array):
	if (work[1]+time[1]) > 59:
		time[0] += 1
		time[1] = 59 - time[1]
	var work_minutes_before_split: int = work[0] - time[0]
	var pomos_from_split: int = abs(time[0] / base_work)
	var minutes_post_split = work_minutes_before_split % base_work 
	if work_minutes_before_split > 0:
		work[0] = minutes_post_split
		if dynamic:
			add_to_rest(true, (abs(minutes_post_split))*60)
	else:
		for i in range(pomos_from_split):
			rest[0] += base_rest
			iterate_pomo()
		if dynamic:
			add_to_rest(true, (abs(minutes_post_split))*60)
		work = [base_work+minutes_post_split, 0]
	ui.update_work(work)
		
func run_timer():
	if running:
		global.pront("starting timer")
		timer.start()
	else:
		global.pront("stoping timer")
		timer.stop()
	
func _on_timer_timeout():
	if global.mute == false and spill == true:
		working = false
		spill = false
		work = [base_work, 0]
		ui.update_work(work)
		update_controls()
	if working:
		global.pront("doing work time updates")
		running_work()
	elif empty and not working:
		timer.stop()
		ui.play_button(running)
	else:
		global.pront("doing rest time updates")
		running_rest()
	signals.update_focus.emit()
	

func running_work():
	if dynamic:
		add_to_rest()

	if spill:
		work[1] += 1
		if work[0] <= base_work and work [1] <= 0:
			timeout()
		elif work[1] > 59:
			work[0] += 1
			work[1] = 0
		ui.update_work(work, true)

	else:
		work[1] -= 1
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
	elif rest[1] <= -1:
		rest[0] -= 1
		rest[1] = 59
	ui.update_rest(rest)

func timeout():
	if working:
		iterate_pomo()
		if global.mute:
			spill = true
		else:
			work[0] = base_work
		working = false if auto_rest else true
		working = true if spill else false
		running = true if auto_rest else false
		ui.update_pomos(pomo)
		
	else:
		if not dynamic:
			rest[0] = base_rest
		global.play_sound(3, audio_work)
		working = true if auto_work else false
		running = true if auto_work else false
		if queue_stop:
			signals.open_editor.emit()
		
	ui.play_button(running)
	ui.switch_button(working, empty)
	run_timer()

func iterate_pomo():
	pomo += 1
	if pomo == base_pomo:
		rest[0] += (base_long - base_rest)
		pomo = 0
		global.play_sound(4, audio_long)
	else:
		global.play_sound(3, audio_rest)
	ui.update_rest(rest)
	ui.update_pomos(pomo)


func add_to_rest(bulk: bool = false, amount: int = 0):
	empty = false
	if bulk:
		var processed: int = int(amount * ratio)
		rest[0] += int(processed / 60)
		rest[1] += processed % 60
		
	else:
		rest[1] += 1 * ratio
		if rest[1] > 59:
			rest[0] += 1
			rest[1] -= 59
	
		
	ui.update_rest(rest)

