extends Control

var touched := false
var touch = null

export(NodePath) var playerNodePath

var pos := Vector2.ZERO

func _ready():
	$Timer.connect("timeout", self, "shoot")

func _physics_process(delta):
	var offset = (get_rect().size.x/2 - $Paddle.get_rect().size.x/2)*Vector2.ONE
	var relative_pos = pos-rect_global_position-rect_size/2
	var dir = relative_pos if relative_pos.length()<get_rect().size.x/2 else (relative_pos).normalized()*get_rect().size.x/2
	$Paddle.rect_position = $Paddle.rect_position.move_toward(offset+(dir if touched else Vector2.ZERO), delta*500)


func _input(event):
	if event is InputEventScreenTouch:
		if not touched and event.pressed and is_in_rect(event.position, get_rect()) :
			touch = event.index
			touched = true
			pos = event.position
			shoot()
		elif touched and event.index==touch and not event.pressed :
			touch=null
			touched=false
			pos = Vector2.ZERO
	
	if event is InputEventScreenDrag:
		if touched and event.index==touch : 
			pos=event.position


func shoot() :
	if (get_node(playerNodePath)==null) : return
	if not get_node(playerNodePath).get_node("CollisionShape2D").get_child(0).can_shoot : return
	if not touched : return
	Events.emit_signal("shoot", (pos-rect_global_position-rect_size/2).normalized())
	$Timer.start()


func is_in_rect(pos, rect) :
	return pos.x > rect.position.x \
		and pos.y > rect.position.y \
		and pos.x < rect.end.x \
		and pos.y < rect.end.y
