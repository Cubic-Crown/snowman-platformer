extends Control

func _on_Settings_pressed():
	print("Settings pressed")

func _on_StartGame_pressed():
	ChangeScene.go_to_level(get_tree(), Save.get_level(), TransitionManager.transitions.FADE)

func _on_ChooseLevel_pressed():
	ChangeScene.go_to_level(get_tree(), "res://Levels/LevelSelection.tscn", TransitionManager.transitions.FADE)
