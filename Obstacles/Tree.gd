extends Area2D

enum states {IDLE, FALLING}
var state
var triggered := false


func _ready() :
	state = states.IDLE
	$AnimationPlayer.play("Idle")
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")

func _physics_process(delta):
	match state :
		states.IDLE : idle_state()
		states.FALLING : falling_state()

func entered(_v) :
	triggered=true
func exited(_v): 
	triggered=false


func idle_state() :
	if triggered and state == states.IDLE :
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Fall")
			state = states.FALLING
			$Timer.start()

func falling_state():
	if $Timer.is_stopped() and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Idle")
			state = states.IDLE
	
