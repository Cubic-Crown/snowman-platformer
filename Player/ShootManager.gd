extends Node2D

export(PackedScene) var snowball

func _ready() :
	Events.connect("shoot", self, "shoot_handler") 
	

func shoot_handler(direction) :
	if not direction : return
	var n = snowball.instance() as RigidBody2D
	n.linear_velocity = direction * 350
	n.global_position = global_position
	owner.get_parent().add_child(n)
