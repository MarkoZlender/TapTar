extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion
@onready var legion_2 = $Legions/legion2

# @onready var all_legions = $Legions.get_children()

# @onready var taken_positions = Dictionary()
# @onready var selected_legions = Dictionary()

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
	#fill_taken_positions()

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


# func check_position(unit: Node, new_legion_position: Vector2i):
# 	taken_positions[unit] = new_legion_position
# 	print("Restricted coords: " + str(taken_positions))


func _on_ui_end_turn():
	legion.set_end_turn()
	legion_2.set_end_turn()
	
	
	

