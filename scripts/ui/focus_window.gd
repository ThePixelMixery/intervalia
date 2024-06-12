extends VBoxContainer

@onready var progress_pomo = $Control_Display/TexProg_Pomo
@onready var progress_min = $Control_Display/TexProg_Pomo/TexProg_Minute

var pomo_light: bool = false 

var minute: bool = true #change to setting
var working: bool = true

func _ready():
	signals.connect("update_focus", check_focus)
	signals.connect("select_set", populate)	

func populate():
	progress_pomo.min_value = global.selected.base_work * -1
	progress_pomo.value = global.selected.work[0] * -1
	progress_min.value = -60
	
func check_focus():

	if working != global.selected.working: 
		working = global.selected.working
		if working:
			progress_pomo.min_value = global.selected.base_work  if working else global.selected.rest[0]

	if working:
		if global.selected.work[0] != progress_pomo.value: progress_pomo.value = global.selected.work[0]* -1
		if minute: progress_min.value = global.selected.work[1]* -1
	else:
		if global.selected.rest[0] != progress_pomo.value: progress_pomo.value = global.selected.rest[0]* -1
		if minute: progress_min.value = global.selected.rest[1]* -1

func _on_check_minutes_toggled(toggled_on:bool):
	progress_min.visible = toggled_on
	minute = toggled_on
	
