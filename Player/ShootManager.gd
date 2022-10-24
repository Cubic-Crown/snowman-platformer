extends Node2D

export(PackedScene) var snowball

func _ready() :
	Events.connect("shoot", self, "shoot_handler") 
	

func shoot_handler(direction) :
	var n = snowball.instance() as RigidBody2D
	n.linear_velocity = direction * 350
	add_child(n)
