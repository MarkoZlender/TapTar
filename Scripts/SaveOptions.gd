class_name SaveOptions extends Resource

const SAVE_OPTIONS_PATH := "user://optionssave.tres"

@export var volume : Resource

func write_options() -> void:
	ResourceSaver.save(self, SAVE_OPTIONS_PATH, 0)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_OPTIONS_PATH)

static func load_options():
	if not ResourceLoader.has_cached(SAVE_OPTIONS_PATH):
		return ResourceLoader.load(SAVE_OPTIONS_PATH, "", 0)

