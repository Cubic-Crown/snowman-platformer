extends Node2D

const PlayerScene = preload("res://Player/Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera: = $Camera2D
onready var timer: = $Timer

export(float) var dieUnderY = 90

func _physics_process(delta):
	var p = get_node_or_null("Player")
	if not p : return
	if p.position.y>dieUnderY : p.player_die()

func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)
	get_node("Player").connect_camera(camera)
	player_spawn_location = get_node("Player").global_position
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("hit_checkpoint", self, "_on_hit_checkpoint")

func _on_player_died():
	$Player.queue_free()
	remove_child($Player)
	timer.start(1.0)
	yield(timer, "timeout")
	var player = PlayerScene.instance()
	player.global_position = player_spawn_location
	add_child(player)
	player.connect_camera(camera)
	Events.emit_signal("player_spawned")
	
func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
