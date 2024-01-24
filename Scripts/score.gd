# static/autoload/singleton for saving and loading score
extends Node

@onready var score: int = 0
@onready var line_counter: int = 0
@onready var path = "user://save_score.dat"

# saves score to file
func save_score(content):
	# C:\Users\user\AppData\Roaming\Godot\app_userdata\TapTar
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ_WRITE)
		while file.get_position() < file.get_length():
			file.get_line()
			line_counter += 1
		file.seek_end()
		file.store_string(str(line_counter + 1) + ". " + str(content) + "\n")
	else:
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(str(line_counter + 1) + ". " + str(content) + "\n") 

# loads score from file
func load_score():
	var file = FileAccess.open("user://save_score.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content
