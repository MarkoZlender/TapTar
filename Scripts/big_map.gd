extends Control

@onready var tilemap = $GroundTiles
@onready var camera_2d = $Camera2D
@onready var legion = $Legions/legion

@onready var legion_3 = $Legions/legion3


@onready var enemy_legion = $EnemyLegions/enemy_legion
@onready var enemy_legion_2 = $EnemyLegions/enemy_legion2

@onready var legion_controller = get_node("/root/Small_map/LegionController")
@onready var winlose = get_node("/root/Small_map/WinLose")

@onready var all_legions = $Legions.get_children()
@onready var all_enemy_legions = $EnemyLegions.get_children()

@onready var mini_menu_continue_button
@onready var mini_menu_main_menu_button
@onready var mini_menu_exit_button


var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()

#
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	character = save_game.character
	$Control/TextureRect.texture = character.portrait
	# setting legion positions
	legion.set_legion_position(Vector2i(1,0))
	
	legion_3.set_legion_position(Vector2i(2,1))

	legion_controller.player_owned_tiles.append(legion.get_legion_position())
	
	legion_controller.player_owned_tiles.append(legion_3.get_legion_position())


	enemy_legion.set_legion_position(Vector2i(17,7))
	legion_controller.enemy_owned_tiles.append(enemy_legion.legion_position)
	#enemy_legion.set_target_position(Vector2i(8,1))
	enemy_legion_2.set_legion_position(Vector2i(18,7))
	legion_controller.enemy_owned_tiles.append(enemy_legion_2.legion_position)

	#enemy_legion_2.set_target_position(Vector2i(10,1))
	
	# check if the player's legion is on a tile and if it is, change the tile
	legion_controller.check_taken_position()

	legion_controller.calculate_gold()
	$UICanvasLayer/UI/GoldLabel.text = str(legion_controller.gold)

	print("Score: "+str(legion_controller.calculate_score()))
	print("Gold: "+str(legion_controller.gold))
	print("Enemy gold: " + str(legion_controller.enemy_gold))
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_movement()
	#legion_controller.check_taken_position()


	
func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		legion_controller.check_taken_position()
		legion_controller.check_engagement()
		$UICanvasLayer/UI/GoldLabel.text = str(legion_controller.gold)

		

	if Input.is_action_just_pressed("exit") and get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/mini_menu") == null:
		var mini_menu_scene = preload("res://Levels/mini_menu.tscn")
		var mini_menu_instance = mini_menu_scene.instantiate()
		$Camera2D/MiniMenuCanvasLayer.add_child(mini_menu_instance)

		mini_menu_continue_button = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/mini_menu/Background/ContinueButton")
		mini_menu_continue_button.pressed.connect( _on_continue_button_pressed)

		mini_menu_main_menu_button = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/mini_menu/Background/MainMenuButton")
		mini_menu_main_menu_button.pressed.connect( _on_main_menu_button_pressed)

		mini_menu_exit_button = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/mini_menu/Background/ExitButton")
		mini_menu_exit_button.pressed.connect( _on_exit_button_pressed)

# mini menu functions ##########################################

func _on_continue_button_pressed():
	get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/mini_menu").queue_free()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Menu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

################################################################


	



# function which executes all the necessary actions when the player ends their turn
func _on_ui_end_turn():
	for unit in all_legions:
		if unit != null:
			unit.set_end_turn()
			legion_controller.check_taken_position()
	for unit in all_enemy_legions:
		if unit != null:
			unit.set_end_turn()
			legion_controller.check_taken_position()
		
	legion_controller.check_engagement()

	legion_controller.calculate_gold()
	$UICanvasLayer/UI/GoldLabel.text = str(legion_controller.gold)
	legion_controller.create_new_enemy_legion()
	winlose.turn_small_map()
	$UICanvasLayer/UI/TurnsLabel.text = "Turns: " + str(30-winlose.turns)


	print("Player ownedpositions: "+str(legion_controller.player_owned_tiles))
	print("Enemy owned positions: "+str(legion_controller.enemy_owned_tiles))

	print("Player owned tiles count: "+str(legion_controller.player_owned_tiles.size()))
	print("Enemy owned tiles count: "+str(legion_controller.enemy_owned_tiles.size()))

	print("Score: "+str(legion_controller.calculate_score()))
	print("Gold: "+str(legion_controller.gold))
	print("Enemy gold: " + str(legion_controller.enemy_gold))
	#legion_controller.check_taken_position()

# camera movement function #####################################

func camera_movement():
	if Input.is_action_pressed("up"):
		camera_2d.position += Vector2(0,-10)
	elif Input.is_action_pressed("down"):
		camera_2d.position += Vector2(0,10)
	elif Input.is_action_pressed("left"):
		camera_2d.position += Vector2(-10,0)
	elif Input.is_action_pressed("right"):
		camera_2d.position += Vector2(10,0)

################################################################
	






func _on_new_legion_button_pressed():
	var new_legion_position = null
	if legion_controller.gold >= 100 and legion_controller.player_owned_tiles.size() > all_legions.size():
		for tile in legion_controller.player_owned_tiles:
			if tile not in legion_controller.taken_positions.values():
				print("New legion")
				var new_legion_scene = preload("res://Objects/legion.tscn")
				var new_legion_instance = new_legion_scene.instantiate()
				$Legions.add_child(new_legion_instance)
				new_legion_position = tile
				new_legion_instance.set_legion_position(new_legion_position)
				all_legions.append(new_legion_instance)
			
				legion_controller.new_legions_created += 1
				legion_controller.calculate_gold()
				$UICanvasLayer/UI/GoldLabel.text = str(legion_controller.gold)

				print("Score: "+str(legion_controller.calculate_score()))
				print("Gold: "+str(legion_controller.gold))
				print("Enemy gold: " + str(legion_controller.enemy_gold))
				break
			else:
				print("No available tiles")
				break
	else:
		print("Not enough gold or no available tiles")


