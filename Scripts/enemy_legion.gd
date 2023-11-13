extends Control

signal legion_selected(selected: bool)

@onready var player_select = $PlayerSelect
@onready var tilemap = current_tilemap
@onready var path_to_next_tile = Array()
@onready var animated_sprite = $PlayerSelect/AnimatedEnemySprite
@onready var sfx_player = get_node("/root/Small_map/SFXPlayer")
@onready var legion_controller = get_node("/root/Small_map/LegionController")
@onready var canvasLayer = get_node("/root/Small_map/CanvasLayer")
@onready var target_position: Vector2i
@onready var current_target_position: Vector2i
@onready var line_2d_enemy = Line2D.new()

@onready var player_legions = get_node("/root/Small_map/Legions").get_children()

@export var current_tilemap: TileMap = null
@export var moved: bool = false
@export var legion_selection: bool
@export var legion_position: Vector2i
@export var neighbours: Array[Vector2i]

@export var old_legion_position: Vector2i
@export var new_position: Vector2i



# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	legion_position = current_tilemap.local_to_map(self.global_position)
	neighbours = current_tilemap.get_surrounding_cells(legion_position)
	legion_selection = false

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite.play("idle")

func set_target_position(new_target_position: Vector2i):
	target_position = new_target_position

func find_player_legion():
	var random_legion = player_legions[randi() % player_legions.size()]
	var random_legion_position = tilemap.local_to_map(random_legion.global_position)
	return random_legion_position
	
		

func movement():
	if path_to_next_tile.size() < 2 or path_to_next_tile == null or path_to_next_tile == []:
		current_target_position = find_player_legion()

	path_to_next_tile = tilemap.getAStarPath(self.global_position, tilemap.map_to_local(current_target_position))
	canvasLayer.line_2d_points = path_to_next_tile

	# for coord in path_to_next_tile:
	# 	print("path_to_next_tile: " + str(tilemap.local_to_map(coord)))

	if path_to_next_tile.size() > 1:
		
		path_to_next_tile.pop_front()
		var vTarget = path_to_next_tile.pop_front()

		if tilemap.local_to_map(vTarget) not in legion_controller.taken_positions.values() and tilemap.local_to_map(vTarget) not in legion_controller.enemy_taken_positions.values():
			#tilemap.freeAStarCell(self.global_position)
			#tilemap.occupyAStarCell(vTarget)
			play_animation(vTarget)
			new_position = tilemap.map_to_local(vTarget)
			legion_position = tilemap.local_to_map(new_position)
			neighbours = tilemap.get_surrounding_cells(legion_position)
			moved = true
			
			if legion_position not in legion_controller.enemy_owned_tiles:
				legion_controller.enemy_owned_tiles.append(tilemap.local_to_map(legion_position))
			else:
				pass
	else:
		print("no path to next tile")
	# TODO else if other legion is on the tile, fight

	if moved == true:
		legion_selection = false
		player_select.button_pressed = false
		#tilemap.occupyAStarCell(self.global_position)
		legion_controller.check_enemy_position(self, tilemap.local_to_map(legion_position))


func play_animation(vTarget):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", vTarget, 0.5)

	if (tilemap.local_to_map(vTarget).x) < (legion_position.x):
		print("Flipping sprite to left", vTarget.x, legion_position.x)
		$PlayerSelect/AnimatedEnemySprite.set_flip_h(true)
	if (tilemap.local_to_map(vTarget).x) > (legion_position.x):
		print("Flipping sprite to right", vTarget.x, legion_position.x)
		$PlayerSelect/AnimatedEnemySprite.set_flip_h(false)

func _on_selected_toggled(button_pressed):
	if button_pressed:
		legion_controller.selected_legions.append(self)
	else:
		legion_controller.selected_legions.erase(self)
	#print("Selected legions: " + str(LegionController.selected_legions))
	legion_selected.emit(button_pressed)

func _on_legion_selected(selected):
	#print("Selected legions: " + str(SmallMap.selected_legions))
	if (selected and moved == false) and legion_controller.selected_legions.size() < 2:
		legion_selection = true

func set_end_turn():
	print("Target position: " + str(target_position))
	# calling movement at the end of the turn so that the enemy legions make moves after the player
	#############################################################################################
	movement()
	#############################################################################################
	moved = false
	legion_selection = false
	player_select.button_pressed = false

func set_legion_position(new_legion_position: Vector2i):
	self.global_position = tilemap.map_to_local(new_legion_position)
	legion_position = tilemap.local_to_map(self.global_position)
	neighbours = tilemap.get_surrounding_cells(legion_position)
	legion_controller.check_enemy_position(self, legion_position)
	#tilemap.occupyAStarCell(self.global_position)

func set_selected(selected: bool):
	legion_selection = selected

func get_legion_position():
	return legion_position

func get_neighbours():
	return neighbours
