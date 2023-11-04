extends Control

signal legion_selected(selected: bool)

@onready var player_select = $PlayerSelect
@onready var tilemap = current_tilemap
@onready var path_to_next_tile
@onready var animated_sprite = $PlayerSelect/AnimatedEnemySprite
@onready var sfx_player = get_node("/root/Small_map/SFXPlayer")
@onready var legion_controller = get_node("/root/Small_map/LegionController")


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


func movement():

	path_to_next_tile = tilemap.getAStarPath(self.global_position, tilemap.map_to_local(Vector2i(8,1)))
	for coord in path_to_next_tile:
		print("path_to_next_tile: " + str(tilemap.local_to_map(coord)))
	if path_to_next_tile.size() > 1:
		
		path_to_next_tile.pop_front()
		var vTarget = path_to_next_tile.pop_front()

		#if tilemap.local_to_map(vTarget) in legion_controller.taken_positions.values():
			#pass
		#else:
		print("vTarget: " + str(vTarget))
		#if tilemap.local_to_map(vTarget) in neighbours:
		if tilemap.local_to_map(vTarget) in neighbours:
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
		legion_controller.check_position(self, tilemap.local_to_map(legion_position))


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
	legion_controller.check_position(self, legion_position)
	#tilemap.occupyAStarCell(self.global_position)

func find_free_position():
	var free_position: Vector2i
	var taken_positions = legion_controller.taken_positions
	var neighbours: Array[Vector2i] = tilemap.get_surrounding_cells(legion_position)
	var free_neighbours: Array[Vector2i] = []
	for neighbour in neighbours:
		if neighbour not in taken_positions.values():
			free_neighbours.append(neighbour)
	if free_neighbours.size() > 0:
		free_position = free_neighbours[randi() % free_neighbours.size()]
	else:
		free_position = legion_position
	return free_position

func set_selected(selected: bool):
	legion_selection = selected

func get_legion_position():
	return legion_position
