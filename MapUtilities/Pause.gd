extends TextureButton


enum states { PAUSED, RUNNING }
var state = states.RUNNING

export(String, FILE, "*.tscn") var quit_path = ""

func _ready():
	set_pause(false)
	connect("button_down", self, "toogle_state")
	get_parent().get_node("PausePanel/AspectRatioContainer/Buttons/Continue").connect("button_up", self, "toogle_state")
	get_parent().get_node("PausePanel/AspectRatioContainer/Buttons/Quit").connect("button_up", self, "quit")



func toogle_state() :
	state = states.PAUSED if state==states.RUNNING else states.RUNNING
	set_pause(state==states.PAUSED)

func quit() :
	get_parent().get_node("PausePanel").visible = false
	ChangeScene.go_to_level(get_tree(), quit_path)


func set_pause(v:bool) :
	get_tree().paused = v
	get_parent().get_node("PausePanel").visible = v


