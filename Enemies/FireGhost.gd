extends Node2D


enum states { IDLE, MOVING, SHOOTING, HURT }
var state = states.IDLE
onready var targetPosition := position
onready var startPosition := global_position
var shootCount:int
var currentlyShot:int

var life = 3

func _ready() :
	get_node("AnimatedSprite/Hitbox").connect("body_entered", self, "hurt")

func hurt(b)->void :
	if not b is SnowBall : return
	$AnimationPlayer.play("hurt")
	life-=1
	state = states.HURT

func getPlayerPosition() :
	var p = owner.get_node_or_null("Player")
	if p == null : return null
	return p.global_position

const SPEED = 50
const MOVING_RANGE = 0

export(PackedScene) var fireBall


func _delta() :
	randomize()

func _physics_process(delta):
	match state :
		states.IDLE : idleState()
		states.MOVING : movingState(delta)
		states.SHOOTING : shootingState()
		states.HURT : hurtState()

func isInRange(v:Vector2)->bool :
	if v==null : return false
	return\
	v.x<=startPosition.x+MOVING_RANGE and \
	v.x>=startPosition.x-MOVING_RANGE and \
	v.y<=startPosition.y+MOVING_RANGE and \
	v.y>=startPosition.y-MOVING_RANGE

func canGoTo(p:Vector2)->bool :
	if p==null : return false
	$RayCast2D.cast_to = p-global_position
	$RayCast2D.force_raycast_update()
	return not $RayCast2D.is_colliding()

func getNextLocation() :
	var p = null
	var angle = (randi()%600) *2*3.14/600.0
	var i=0
	while i<1000 and (p==null or not isInRange(p) or not canGoTo(p)) :
		i+=1
		p = global_position+Vector2.DOWN.rotated(angle)*(20+randi()%30)
	return p

func hurtState() :
	if not $AnimationPlayer.is_playing() :
		if life<=0 : queue_free()
		$AnimationPlayer.play("wave")
		targetPosition = getNextLocation()
		state = states.MOVING

func idleState() :
	var pos= getPlayerPosition()
	if pos==null: return
	if $Timer.is_stopped() and pos.distance_to(global_position)<350:
		targetPosition = getNextLocation()
		state = states.MOVING

func movingState(delta) :
	lookPlayer()
	global_position = global_position.move_toward(targetPosition, delta*SPEED)
	if global_position.distance_to(targetPosition) < 0.5 :
		shootCount = 3+randi()%6
		currentlyShot = 0
		state = states.SHOOTING
		$AnimatedSprite.frame = 1

func shootingState() :
	if $Timer2.is_stopped() :
		shoot()
		currentlyShot+=1
		$Timer2.start();
	if currentlyShot==shootCount :
		$Timer.start()
		state = states.IDLE
		$AnimatedSprite.frame = 0

func lookPlayer() :
	var pos = getPlayerPosition()
	if pos==null: return
	$AnimatedSprite.flip_h = pos.x>=global_position.x
	
func shoot() :
	var pos = getPlayerPosition()
	if pos==null: return
	lookPlayer()
	var f = fireBall.instance()
	f.global_position=$AnimatedSprite.global_position+Vector2.DOWN*10
	f.shootDirection = (pos-global_position).normalized()
	owner.add_child(f)
	
