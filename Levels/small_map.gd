extends Control

signal legion_positions

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion
@onready var legion_2 = $Legions/legion2

@onready var all_legions = $Legions.get_children()

var taken_positions: Array[Vector2i]

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
	# get all positions on the tilemap taken by legions
	get_taken_positions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("legion_positions", taken_positions)
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


func get_taken_positions():
	# add all taken coordinates to Array
	for unit in all_legions:
		taken_positions.append(unit.get_legion_position())

func _on_ui_end_turn():
	legion.set_end_turn()
	legion_2.set_end_turn()

