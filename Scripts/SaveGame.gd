class_name SaveGame extends Resource

const SAVE_GAME_PATH := "user://gamesave.tres"

@export var character : Resource

func write_game() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH, 0)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_game():
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH, "", 0)
