extends Node

const HURT = preload("res://Assets/Audio/HURT.wav")
const JUMP = preload("res://Assets/Audio/JUMP.wav")

onready var audioPlayers = get_node("AudioPlayers")

func play_sound(sound):
	print($"AudioPlayers".get_children())
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
