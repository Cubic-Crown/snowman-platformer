tool
extends Node2D

export(float) var speed=1

func _physics_process(delta):
	rotate(delta*speed)
