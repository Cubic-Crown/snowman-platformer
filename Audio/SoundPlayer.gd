extends Node

const HURT = preload("res://Audio/Hurt.wav")
const JUMP = preload("res://Audio/Jump.wav")

onready var audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
