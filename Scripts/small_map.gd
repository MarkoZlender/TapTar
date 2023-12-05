extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion
@onready var legion_2 = $Legions/legion2
@onready var legion_3 = $Legions/legion3


@onready var enemy_legion = $EnemyLegions/enemy_legion
@onready var enemy_legion_2 = $EnemyLegions/enemy_legion2

@onready var legion_controller = get_node("/root/Small_map/LegionController")

@onready var all_legions = $Legions.get_children()
@onready var all_enemy_legions = $EnemyLegions.get_children()
@onready var mini_menu


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
	legion_3.set_legion_position(Vector2i(15,5))

	legion_controller.player_owned_tiles.append(legion.get_legion_position())
	legion_controller.player_owned_tiles.append(legion_2.get_legion_position())
	legion_controller.player_owned_tiles.append(legion_3.get_legion_position())


	enemy_legion.set_legion_position(Vector2i(3,2))
	legion_controller.enemy_owned_tiles.append(enemy_legion.get_legion_position())
	#enemy_legion.set_target_position(Vector2i(8,1))
	enemy_legion_2.set_legion_position(Vector2i(5,3))
	legion_controller.enemy_owned_tiles.append(enemy_legion_2.get_legion_position())

	#enemy_legion_2.set_target_position(Vector2i(10,1))
	
	# check if the player's legion is on a tile and if it is, change the tile
	legion_controller.check_taken_position()

	#mini_menu.Background.ContinueButton.pressed.connect("pressed()", _on_continue_button_pressed)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement()

func _on_continue_button_pressed():
	print("continue button pressed")
	
func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		legion_controller.check_taken_position()

	if Input.is_action_just_pressed("exit"):
		var mini_menu_scene = preload("res://Levels/mini_menu.tscn")
		var mini_menu_instance = mini_menu_scene.instantiate()
		mini_menu = get_node("/root/Small_map/mini_menu")
		add_child(mini_menu_instance)
	

# function which executes all the necessary actions when the player ends their turn
func _on_ui_end_turn():
	for unit in all_legions:
		unit.set_end_turn()
		legion_controller.check_taken_position()
	for unit in all_enemy_legions:
		unit.set_end_turn()
		legion_controller.check_taken_position()
		
	legion_controller.check_engagement()


func camera_movement():
	if Input.is_action_pressed("up"):
		camera_2d.position += Vector2(0,-10)
	elif Input.is_action_pressed("down"):
		camera_2d.position += Vector2(0,10)
	elif Input.is_action_pressed("left"):
		camera_2d.position += Vector2(-10,0)
	elif Input.is_action_pressed("right"):
		camera_2d.position += Vector2(10,0)
	
	
	

