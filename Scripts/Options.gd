extends Control

var _save = SaveOptions
var volume = VolumeOptions.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_or_load_save()
	$MusicVolumeSlider.value = volume.music_volume
	$SFXVolumeSlider.value = volume.sfx_volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _create_or_load_save() -> void:
	if SaveOptions.save_exists():
		_save = SaveOptions.load_options() as SaveOptions
	else:
		_save = SaveOptions.new()
		
		_save.volume = VolumeOptions.new()
		_save.write_options()
		
	volume = _save.volume

func _on_back_button_pressed():
	self.queue_free()
	

func _on_music_volume_slider_value_changed(value):
	volume.music_volume = value
	_save.volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_sfx_volume_slider_value_changed(value):
	volume.sfx_volume = value
	_save.volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_save_button_pressed():
	_save.write_options()
