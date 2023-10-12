class_name SaveSystem
var save_options = SaveOptions.new()
var save_game = SaveGame.new()

func create_or_load_save_options() -> void:
	if SaveOptions.save_exists():
		save_options = SaveOptions.load_options() as SaveOptions
	else:
		save_options = SaveOptions.new()
		
		save_options = VolumeOptions.new()
		save_options.write_options()
		
	#volume = _save.volume

func create_or_load_save_game() -> bool:
	if SaveGame.save_exists():
		save_game = SaveGame.load_game() as SaveGame
		return true
	else:
		save_game = SaveGame.new()
		
		save_game.character = Character.new()
		save_game.write_game()
		
	#character = save_game.character
	return false

