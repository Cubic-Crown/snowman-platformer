tool
extends Sprite


var tex : Image

export(int) var radius=SnowBallData.MIN_RADIUS setget set_radius, get_radius
export(String, FILE, "*.tscn") var target_level_path = ""

var rotation_speed := 0.0
var snowballsData := preload("res://Data/snowballs.tres")

func set_radius(v):
	if v>SnowBallData.MAX_RADIUS or v<SnowBallData.MIN_RADIUS : return
	Events.emit_signal("snow_quantity_change", v-SnowBallData.MIN_RADIUS)
	radius = v
	snowballsData.canShoot = v!=SnowBallData.MIN_RADIUS
	update()

func get_radius():
	return radius


func checkWin() :
	if owner.get_parent() == null : return false
	var tm = owner.get_parent().get_node_or_null("TileMap")
	if tm==null : return false
	var p = tm.world_to_map(owner.global_position+Vector2.DOWN*3)
	if tm.get_cell(p.x, p.y) in [36] :
		Events.emit_signal("win")
		ChangeScene.go_to_level(get_tree(), target_level_path)

func isOnSnow() :
	if owner.get_parent() == null : return false
	var tm = owner.get_parent().get_node_or_null("TileMap")
	if tm==null : return false
	var p = tm.world_to_map(owner.global_position+Vector2.DOWN*3)
#	print(tm.get_cell(p.x, p.y)==2)
	return tm.get_cell(p.x, p.y) in [2, 31, 32]


var counter := 0
func _ready():
	if Engine.is_editor_hint() : return
	set_radius(SnowBallData.MIN_RADIUS)
	Events.connect("shoot", self, "shoot_handler")

func shoot_handler(_direction) :
	set_radius(radius-1)



func _physics_process(delta):
	if Engine.is_editor_hint() : return
	checkWin()
	var player = get_parent().get_parent()
#	var col = player.get_last_slide_collision().collider as  CollisionObject2D 
#	if col!=null : print(col.get_collision_layer_bit(23)) 
	if player.is_on_floor() and (not player.is_on_wall()) and (Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right")) :
		rotation_speed += 3*delta * (1-2*Input.get_action_strength("ui_left"))
		if isOnSnow() :
			counter+=1
			if counter==SnowBallData.STEPS_TO_GROW :
				set_radius(radius+1)
				counter=0
	elif player.is_on_floor() or sign(player.velocity.x)!=sign(rotation_speed) : 
		rotation_speed *= 0.6
	if Input.is_action_just_pressed("ui_down") : set_radius(radius-1)
	rotation_speed = min(rotation_speed, SnowBallData.MAX_ROTATION_SPEED)
	rotation_speed = max(rotation_speed, -SnowBallData.MAX_ROTATION_SPEED)
	rotation += rotation_speed
#	get_child(0).global_rotation_degrees=0
	
func update() :
	var img = Image.new()
	var s = SnowBallData.MAX_RADIUS*2;
	img.create(s, s, false, Image.FORMAT_RGBA8)
	img.lock()
	for x in range(s) :
		for y in range(s) :
			var xx = x - s/2
			var yy = y - s/2
			var col = Color(223.0/255, 246.0/255, 245.0/255) if sqrt(xx*xx+yy*yy)<radius else Color(0,0,0,0)
#			var col = Color(223.0/255, 246.0/255, 245.0/255) if sqrt(xx*xx+yy*yy)<radius-2 else Color(52/255.0,85/255.0,81.0/255) if sqrt(xx*xx+yy*yy)<radius else Color(0,0,0,0)
			img.set_pixel(x,y,col)
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	tex.flags = 0
	texture = tex
	if not get_parent() is CollisionShape2D: return
	get_parent().shape.radius = radius-1
	get_parent().position.y = -radius+2
