extends Node2D

var _save_game = SaveGame.load_game() as SaveGame
var character = Character.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	character = _save_game.character
	$TextEdit.text = str(character.character_name) + str(character.martial_prowess) + str(character.charisma) + str(character.intellect) + str(character.cunning)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
