extends Control

var save_system = SaveSystem.new()
var volume = VolumeOptions.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$SaveButton.grab_focus()
	
	save_system.create_or_load_save_options()
	volume = save_system.save_options.volume
	
	
	$MusicVolumeSlider.value = volume.music_volume
	$SFXVolumeSlider.value = volume.sfx_volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_button_pressed():
	self.queue_free()
	

func _on_music_volume_slider_value_changed(value):
	volume.music_volume = value
	save_system.save_options.volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_sfx_volume_slider_value_changed(value):
	volume.sfx_volume = value
	save_system.save_options.volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_save_button_pressed():
	save_system.save_options.write_options()
