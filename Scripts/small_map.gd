extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion
@onready var legion_2 = $Legions/legion2
@onready var enemy_legion = $Legions/enemy_legion

@onready var player_owned_tiles = LegionController.player_owned_tiles

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
	player_owned_tiles.append(Vector2i(5,1))
	player_owned_tiles.append(Vector2i(6,1))
	#enemy_legion.set_legion_position(Vector2i(5,5))
	# check if the player's legion is on a tile and if it is, change the tile
	check_taken_position()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement()
	
func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		check_taken_position()
	

func camera_movement():
	if Input.is_action_pressed("up"):
		camera_2d.position += Vector2(0,-10)
	elif Input.is_action_pressed("down"):
		camera_2d.position += Vector2(0,10)
	elif Input.is_action_pressed("left"):
		camera_2d.position += Vector2(-10,0)
	elif Input.is_action_pressed("right"):
		camera_2d.position += Vector2(10,0)

# check if the player's legion is on a tile and if it is, change the tile
func check_taken_position():
	for tile_coord in player_owned_tiles:
		tilemap.set_cell(1, tile_coord, 2, Vector2i(3,0), 0)

# function which executes all the necessary actions when the player ends their turn
func _on_ui_end_turn():
	for unit in all_legions:
		unit.set_end_turn()
	
	
	

