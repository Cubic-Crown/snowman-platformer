extends Node2D

class_name SnowBall


func _ready():
	$Timer.start()
	$Timer.connect("timeout", self, "disappear")

func disappear() :
	queue_free()
