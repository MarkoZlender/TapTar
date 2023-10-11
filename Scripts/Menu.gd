extends Control

var _save = SaveOptions
var _save_game = SaveGame

var volume = VolumeOptions.new()
var character = Character.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Buttons/StartButton.grab_focus()
	# load saved options
	_create_or_load_save_options()
	_save = SaveOptions.load_options() as SaveOptions
	volume = _save.volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume.sfx_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _create_or_load_save_options() -> void:
	if SaveOptions.save_exists():
		_save = SaveOptions.load_options() as SaveOptions
	else:
		_save = SaveOptions.new()
		
		_save.volume = VolumeOptions.new()
		_save.write_options()
		
	volume = _save.volume

# function for loading and saving game
func _create_or_load_save_game() -> bool:
	if SaveGame.save_exists():
		_save_game = SaveGame.load_game() as SaveGame
		return true
	else:
		_save_game = SaveGame.new()
		
		_save_game.character = Character.new()
		_save_game.write_game()
		
	character = _save_game.character
	return false

func _on_start_button_pressed():
	if _create_or_load_save_game():
		get_tree().change_scene_to_file("res://Levels/Level_{level_number}.tscn".format({"level_number": str(character.last_level)}))
	else:
		var customization = preload("res://Levels/CharacterCustomization.tscn")
		var customization_instance = customization.instantiate()
		add_child(customization_instance)

func _on_options_button_pressed():
	var options = preload("res://Levels/Options.tscn")
	var options_instance = options.instantiate()
	add_child(options_instance)
	$Buttons/StartButton.grab_focus()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_story_button_pressed():
	var story = preload("res://Levels/Story.tscn")
	var story_instance = story.instantiate()
	add_child(story_instance)
	$Buttons/StartButton.grab_focus()


func _on_delete_progress_pressed():
	if FileAccess.file_exists("user://gamesave.tres"):
		DirAccess.remove_absolute("user://gamesave.tres")
		OS.alert("Save deleted", "Notification")
	else:
		OS.alert("Save file not found.", "Notification")
