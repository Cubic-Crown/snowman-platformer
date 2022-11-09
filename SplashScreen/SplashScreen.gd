extends Control

export(String, FILE, "*.tscn") var menu_level_path = ""

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "menu")


func menu(_n) :
	 ChangeScene.go_to_level(get_tree(), menu_level_path, TransitionManager.transitions.FADE)
