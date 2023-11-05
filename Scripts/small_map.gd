extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion
@onready var legion_2 = $Legions/legion2
@onready var enemy_legion = $Legions/enemy_legion

@onready var legion_controller = get_node("/root/Small_map/LegionController")

@onready var all_legions = $Legions.get_children()


var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	character = save_game.character
	$Control/TextureRect.texture = character.portrait
	# setting legion positions
	legion.set_legion_position(Vector2i(5,1))
	legion_2.set_legion_position(Vector2i(6,1))
	legion_controller.player_owned_tiles.append(legion.get_legion_position())
	legion_controller.player_owned_tiles.append(legion_2.get_legion_position())
	enemy_legion.set_legion_position(Vector2i(5,2))
	legion_controller.enemy_owned_tiles.append(enemy_legion.get_legion_position())
	
	# check if the player's legion is on a tile and if it is, change the tile
	legion_controller.check_taken_position()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement()
	
func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		legion_controller.check_taken_position()
	

# function which executes all the necessary actions when the player ends their turn
func _on_ui_end_turn():
	for unit in all_legions:
		unit.set_end_turn()
		legion_controller.check_taken_position()


func camera_movement():
	if Input.is_action_pressed("up"):
		camera_2d.position += Vector2(0,-10)
	elif Input.is_action_pressed("down"):
		camera_2d.position += Vector2(0,10)
	elif Input.is_action_pressed("left"):
		camera_2d.position += Vector2(-10,0)
	elif Input.is_action_pressed("right"):
		camera_2d.position += Vector2(10,0)
	
	
	

