extends Control

var _save = SaveOptions
var volume = VolumeOptions.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Buttons/StartButton.grab_focus()
	_save = SaveOptions.load_options() as SaveOptions
	volume = _save.volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume.sfx_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")


func _on_options_button_pressed():
	var options = preload("res://Levels/Options.tscn")
	var options_instance = options.instantiate()
	add_child(options_instance)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_story_button_pressed():
	var story = preload("res://Levels/Story.tscn")
	var story_instance = story.instantiate()
	add_child(story_instance)
