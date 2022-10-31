extends Area2D

var shootDirection

func _ready() :
	connect("body_entered", self, "disappear")
	Events.connect("player_spawned", self, "queue_free")
	$Timer.start()

func _physics_process(delta):
	translate(shootDirection)
	if $Timer.is_stopped() : disappear(null)

func disappear(body) :
		queue_free()
