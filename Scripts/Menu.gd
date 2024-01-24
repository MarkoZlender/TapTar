extends Control

var save_system = SaveSystem.new()

var volume = VolumeOptions.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Buttons/StartButton.grab_focus()
	# create or load saved options
	save_system.create_or_load_save_options()
	# set options
	volume = save_system.save_options.volume
	# set saved volume values
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume.sfx_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	if save_system.create_or_load_save_game():
		get_tree().change_scene_to_file(save_system.save_game.character.map)
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


func _on_scoreboard_button_pressed():
	var score = preload("res://Levels/ScoreBoard.tscn")
	var score_instance = score.instantiate()
	add_child(score_instance)
