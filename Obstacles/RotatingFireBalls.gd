tool
extends Node2D


export(int) var count setget set_count
export(float) var speed=1
export(float) var spacing = 30 setget set_spacing
export(int) var offset = 0 setget set_offset
export(float) var angleOffset = 0 setget set_angle_offset
export(bool) var crossed = false setget set_crossed

var fireBall = preload("res://Obstacles/FireBall.tscn")


func _physics_process(delta):
	$FireBallsParent.rotate(delta*speed)

func set_spacing(v):
	spacing=v
	update()
	
func set_crossed(v):
	crossed=v
	update()

func set_offset(v):
	offset=v
	update()

func set_count(v) :
	count = v
	update()


func set_angle_offset(v) :
	angleOffset = v
	update()

func _ready():
	rotate(angleOffset)
	update()


func update() :
	if get_node_or_null("FireBallsParent") == null : return
	delete_children($FireBallsParent)
	for i in range(count) :
		var b = fireBall.instance()
		b.position.x = (i+offset)*spacing
		add_child_fr($FireBallsParent, b)
	if crossed :
		for i in range(count) :
			var b = fireBall.instance()
			b.position.y = (i+offset)*spacing
			add_child_fr($FireBallsParent, b)


static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


static func add_child_fr(node, child):
	node.add_child(child)
	if Engine.is_editor_hint() : child.set_owner(node)
