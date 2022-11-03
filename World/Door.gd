tool
extends Area2D

class_name Door

export(String, FILE, "*.tscn") var target_level_path = ""

export(bool) var locked = true setget setLocked
export(bool) var boss = false setget setBoss

func updateSprite():
	for c in range(4) : get_children()[c].visible = false
	get_node(("Boss" if boss else "") + ("Locked" if locked else "Unlocked")).visible = true

func setBoss(v):
	boss=v
	updateSprite()

func setLocked(v):
	locked=v
	updateSprite()


var player = false

func _process(_delta):
	if Engine.is_editor_hint() : return
	if not player: return
	if not player.is_on_floor(): return
	if Input.is_action_just_pressed("ui_up"):
		if target_level_path.empty(): return
		ChangeScene.go_to_level(get_tree(), target_level_path)

func _on_Door_body_entered(body):
	if locked : return
	if not body is Player: return
	body.on_door = true
	player = body

func _on_Door_body_exited(body):
	if locked : return
	if not body is Player: return
	body.on_door = false
	player = null
	
