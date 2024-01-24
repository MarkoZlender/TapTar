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
@onready var random_legion_position: Vector2i
@onready var health = 50
@onready var engaged = false

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
	current_tilemap = get_node("/root/Small_map/GroundTiles")
	tilemap = current_tilemap
	legion_position = current_tilemap.local_to_map(self.global_position)
	neighbours = current_tilemap.get_surrounding_cells(legion_position)
	legion_selection = false

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite.play("idle")

func set_target_position(new_target_position: Vector2i):
	target_position = new_target_position

# finds random player legion to move towards
func find_player_legion():
	if player_legions.size() != 0:
		var random_legion = null
		while random_legion == null:
			random_legion = player_legions[randi() % player_legions.size()]
		random_legion_position = tilemap.local_to_map(random_legion.global_position)
		return random_legion_position
	else:
		print("Player legions is empty")
	

func movement():
	player_legions = get_node("/root/Small_map/Legions").get_children()
	if player_legions.size() == 0:
		print("Player legions is empty")
	else:
		var target_legion = null
		for legion in player_legions:
			if legion and legion.get_legion_position() == current_target_position:
				target_legion = legion
				break

		if target_legion == null or (target_legion and target_legion.get_legion_position() != current_target_position):
			current_target_position = find_player_legion()

		if path_to_next_tile == null or path_to_next_tile == [] or path_to_next_tile.size() == 0:
			current_target_position = find_player_legion()
		

		path_to_next_tile = tilemap.getAStarPath(self.global_position, tilemap.map_to_local(current_target_position))
		canvasLayer.line_2d_points = path_to_next_tile

		if path_to_next_tile.size() > 1:
			
			path_to_next_tile.pop_front()
			var vTarget = path_to_next_tile.pop_front()

			if tilemap.local_to_map(vTarget) not in legion_controller.enemy_taken_positions.values():

				play_animation(vTarget)
				new_position = tilemap.map_to_local(vTarget)
				legion_position = tilemap.local_to_map(new_position)
				neighbours = tilemap.get_surrounding_cells(legion_position)
				moved = true

				if self.engaged == false:
					legion_controller.check_enemy_owned_tiles(tilemap.local_to_map(legion_position))
					legion_controller.player_owned_tiles.erase(tilemap.local_to_map(legion_position))
				
		else:
			print("no path to next tile")

		if moved == true:
			legion_selection = false
			player_select.button_pressed = false
			legion_controller.check_enemy_position(self, tilemap.local_to_map(legion_position))


func play_animation(vTarget):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", vTarget, 0.5)

	if (tilemap.local_to_map(vTarget).x) < (legion_position.x):
		$PlayerSelect/AnimatedEnemySprite.set_flip_h(true)
	if (tilemap.local_to_map(vTarget).x) > (legion_position.x):
		$PlayerSelect/AnimatedEnemySprite.set_flip_h(false)

func _on_selected_toggled(button_pressed):
	if button_pressed:
		legion_controller.selected_legions.append(self)
	else:
		legion_controller.selected_legions.erase(self)
	legion_selected.emit(button_pressed)

func _on_legion_selected(selected):
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
	player_legions = get_node("/root/Small_map/Legions").get_children()

func set_legion_position(new_legion_position: Vector2i):
	self.global_position = tilemap.map_to_local(new_legion_position)
	legion_position = tilemap.local_to_map(self.global_position)
	neighbours = tilemap.get_surrounding_cells(legion_position)
	legion_controller.check_enemy_position(self, legion_position)

func set_engaged(engaged_value: bool):
	self.engaged = engaged_value

func set_selected(selected: bool):
	legion_selection = selected

func get_legion_position():
	return tilemap.local_to_map(legion_position)

func get_neighbours():
	return neighbours
