extends VBoxContainer

### Real ###
@onready var progress_pomo = $Control_Display/TexProg_Pomo
@onready var progress_min = $Control_Display/TexProg_Pomo/TexProg_Minute

var minute: bool = true #change to setting
var working: bool = true

func _ready():
	signals.connect("update_focus", check_focus)
	signals.connect("select_set", populate)	

func populate():
	progress_pomo.min_value = global.selected.base_work * -1
	progress_pomo.value = global.selected.work[0] * -1
	progress_min.value = -60

func check_focus(fresh: bool = false):
	if working != global.selected.working: 
		working = global.selected.working

	if fresh:
		set_minute()

	if global.selected.spill == true:
		if minute: 
			if progress_min.max_value != 0: set_minute()
			progress_min.value = global.selected.work[1]

	elif working:
		if progress_pomo.value != global.selected.work[0]* -1:
			update_minute(global.selected.work[0]* -1)
		if minute: progress_min.value = global.selected.work[1]* -1

	else:
		if progress_pomo.value != global.selected.rest[0]* -1:
			update_minute(global.selected.rest[0]* -1)
		if minute: progress_min.value = global.selected.rest[1]* -1
	
func set_minute():
	if working and global.selected.spill == true:
		progress_min.min_value = 0
		progress_min.max_value = 60
	
	elif working:
		progress_pomo.min_value = global.selected.base_work * -1
		progress_pomo.value = global.selected.work[0] * -1
		progress_min.min_value = -60
		progress_min.value = -60
		progress_min.max_value = 0

	else:
		progress_pomo.min_value = global.selected.rest[0] * -1
		progress_pomo.value = global.selected.rest[0] * -1
		progress_min.min_value = -60
		progress_min.value = -60
		progress_min.max_value = 0

func update_minute(minutes:int):
	progress_pomo.value =  minutes

func _on_check_minutes_toggled(toggled_on:bool):
	progress_min.visible = toggled_on
	minute = toggled_on
