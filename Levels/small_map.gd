extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $legion
@onready var legion_2 = $legion2




var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	character = save_game.character
	$Control/TextureRect.texture = character.portrait
	#legion.set_legion_position(Vector2i(0,1))

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement()

func camera_movement():
	if Input.is_action_pressed("up"):
		camera_2d.position += Vector2(0,-10)
	elif Input.is_action_pressed("down"):
		camera_2d.position += Vector2(0,10)
	elif Input.is_action_pressed("left"):
		camera_2d.position += Vector2(-10,0)
	elif Input.is_action_pressed("right"):
		camera_2d.position += Vector2(10,0)


func _on_ui_end_turn():
	legion.set_end_turn()
	legion_2.set_end_turn()

