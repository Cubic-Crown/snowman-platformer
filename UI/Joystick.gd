extends Control

var touched := false
var touch = null
var can_shoot := false

var snowballsData := preload("res://Data/snowballs.tres")

var pos := Vector2.ZERO

func _ready():
	$Timer.connect("timeout", self, "shoot")

func _physics_process(delta):
	var offset = (get_rect().size.x/2 - $Paddle.get_rect().size.x/2)*Vector2.ONE
	var relative_pos = pos-rect_global_position-rect_size/2
	var dir = relative_pos if relative_pos.length()<get_rect().size.x/2 else (relative_pos).normalized()*get_rect().size.x/2
	$Paddle.rect_position = $Paddle.rect_position.move_toward(offset+(dir if touched else Vector2.ZERO), delta*500)
	if dir.length()>get_rect().size.x/2*0.9 and $Timer.is_stopped() : shoot()
	if dir.length()<get_rect().size.x/2*0.9 : $Timer.stop()

func _input(event):
	if event is InputEventScreenTouch:
		if not touched and event.pressed and is_in_rect(event.position, get_rect()) :
			touch = event.index
			touched = true
			pos = event.position
#			shoot()
		elif touched and event.index==touch and not event.pressed :
			touch=null
			touched=false
			pos = Vector2.ZERO
	
	if event is InputEventScreenDrag:
		if touched and event.index==touch : 
			pos=event.position


func shoot() :
	if not snowballsData.canShoot : return
	if not touched : return
	Events.emit_signal("shoot", (pos-rect_global_position-rect_size/2).normalized())
	$Timer.start()


func is_in_rect(pos, rect) :
	return pos.x > rect.position.x \
		and pos.y > rect.position.y \
		and pos.x < rect.end.x \
		and pos.y < rect.end.y
