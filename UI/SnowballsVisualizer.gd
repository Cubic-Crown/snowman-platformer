extends Node

export(Texture) var visulaizerIcon

func _ready():
	for i in range(SnowBallData.MAX_RADIUS-SnowBallData.MIN_RADIUS) :
		var icon = TextureButton.new()
		icon.texture_normal = visulaizerIcon
		add_child(icon)
	
	Events.connect("snow_quantity_change", self, "quantity_change_handler")
	quantity_change_handler(0)
	


func quantity_change_handler(qtty):
	qtty-=1
	for i in range(10) :
		if i<=qtty : get_child(i).show()
		else : get_child(i).hide()
