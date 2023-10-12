extends Node2D

var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	character = save_game.character
	$TextureRect.texture = character.portrait


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
