extends Area2D

var player = null


func _physics_process(delta):
	if not player : return
	if $Timer.is_stopped() : 
		player.hurt()
		$Timer.start()

func _on_Hitbox_body_entered(body):
	if body is Player:
		player = body
		body.hurt()
		$Timer.start()

func death_handler() :
	player = null;

func _on_Hitbox_body_exited(body):
	if body is Player:
		player = null

