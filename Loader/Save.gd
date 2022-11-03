extends Node

const SAVE_FILE: String = "user://savegame.save"

var game_info = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[Save] Loading save file...")
	load_data()
	print(game_info)

# Save the game data to a file
func save_data():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(game_info)
	load_data()

# Load the save file
func load_data():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		print("[Save] Save file not found, creating new one")
		game_info = {
			"level": 1,
			"score": 0,
			"lvlList": [
				"res://Levels/Lvl1.tscn",
				"res://Levels/Lvl2.tscn",
				"res://Levels/Lvl3.tscn",
				"res://Levels/Lvl4.tscn",
				"res://Levels/Lvl5.tscn",
				"res://Levels/Lvl6.tscn",
				"res://Levels/Lvl7.tscn",
				"res://Levels/Lvl8.tscn",
				"res://Levels/Lvl9.tscn"
			]
		}
		save_data()
	else:
		var error = file.open(SAVE_FILE, File.READ)
		if error != OK:
			print("[Save] Error opening save file ;-;")
		else:
			game_info = file.get_var()
			print(game_info)
			print("[Save] Save file loaded :)")
		#game_info = file.get_var()

# Get the current level scene path
func get_level() -> String:
	return game_info.lvlList[game_info.level - 1]

# Update level and save
func update_level(level:int):
	game_info["level"] = level
	save_data()
