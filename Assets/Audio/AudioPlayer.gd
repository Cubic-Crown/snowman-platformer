extends Node

func _ready():
	pass
	
func play_sound(sound_name):
	var sound = get_node(sound_name)
	sound.play()

func stop_sound(sound_name):
	var sound = get_node(sound_name)
	sound.stop()
