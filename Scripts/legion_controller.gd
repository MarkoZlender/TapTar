extends Node

# tiles on which legions are currently standing ###############################
@onready var taken_positions = Dictionary()
@onready var enemy_taken_positions = Dictionary()
###############################################################################

@onready var selected_legions = Array()

# all tiles that are owned by the player and the enemy ########################
@onready var player_owned_tiles = Array()
@onready var enemy_owned_tiles = Array()
###############################################################################

@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null

@onready var sfx_player = get_node("/root/Small_map/SFXPlayer")
@onready var enemy_legions = get_node("/root/Small_map/EnemyLegions")
@onready var small_map = get_node("/root/Small_map")
@onready var combat_scene = preload("res://Levels/Combat.tscn")

@onready var gold = 0
@onready var enemy_gold = 0
@onready var new_legions_created = 0
@onready var new_enemy_legions_created = 0



@export var tilemap: TileMap = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_position(unit: Node, new_legion_position: Vector2i):
	taken_positions[unit] = new_legion_position
	#print("Restricted coords: " + str(taken_positions))

func check_enemy_position(unit: Node, new_legion_position: Vector2i):
	enemy_taken_positions[unit] = new_legion_position
	#print("Restricted coords: " + str(taken_positions))

func check_player_owned_tiles(taken_position):
	if taken_position not in player_owned_tiles:
		player_owned_tiles.append(taken_position)
		
		if taken_position in enemy_owned_tiles:
			enemy_owned_tiles.erase(taken_position)
	else:
		pass

func check_enemy_owned_tiles(taken_position):
	if taken_position not in enemy_owned_tiles:
		enemy_owned_tiles.append(taken_position)

		#if taken_position in player_owned_tiles:
			#player_owned_tiles.erase(taken_position)
	else:
		pass

# check if the player's legion is on a tile and if it is, change the tile
func check_taken_position():
	for tile_coord in player_owned_tiles:
		tilemap.set_cell(1, tile_coord, 2, Vector2i(3,0), 0)
	for tile_coord in enemy_owned_tiles:
		tilemap.set_cell(1, tile_coord, 2, Vector2i(3,1), 0)

func get_player_engaged_legion(tile_coord):
	for legion in taken_positions:
		if legion != null and taken_positions[legion] == tile_coord:
			return legion

func get_enemy_engaged_legion(tile_coord):
	for legion in enemy_taken_positions:
		if legion != null and enemy_taken_positions[legion] == tile_coord:
			return legion

func get_current_engaged_player_legion():
	return current_engaged_player_legion

func get_current_engaged_enemy_legion():
	return current_engaged_enemy_legion

func set_current_engaged_player_legion(legion):
	current_engaged_player_legion = legion

func set_current_engaged_enemy_legion(legion):
	current_engaged_enemy_legion = legion

func check_engagement():
	for tile_coord in taken_positions.values():
		if tile_coord in enemy_taken_positions.values():

			current_engaged_player_legion = get_player_engaged_legion(tile_coord)
			current_engaged_enemy_legion = get_enemy_engaged_legion(tile_coord)

			if !current_engaged_player_legion.engaged and !current_engaged_enemy_legion.engaged:
				current_engaged_player_legion.set_engaged(true)
				current_engaged_enemy_legion.set_engaged(true)

				play_sound_effect()
				
				var combat_scene_instance = combat_scene.instantiate()
				add_child(combat_scene_instance)
			else:
				pass
	

func play_sound_effect():
	sfx_player.stream = load("res://Resources/Sound/SFX/flame-big.ogg")
	sfx_player.play()

# score and resources functions #################################

func calculate_gold():
	gold = 0
	enemy_gold = 0
	for tile in player_owned_tiles:
		var tile_data : TileData = tilemap.get_cell_tile_data(0, Vector2i(tile[0], tile[1]))
		var is_building: bool = tile_data.get_custom_data("building")
		if is_building:
			gold += 20
		else:
			gold += 10
	gold -= new_legions_created * 10

	for tile in enemy_owned_tiles:
		var tile_data : TileData = tilemap.get_cell_tile_data(0, Vector2i(tile[0], tile[1]))
		if tile_data == null:
			continue
		else:
			var is_building: bool = tile_data.get_custom_data("building")
			if is_building:
				enemy_gold += 20
			else:
				enemy_gold += 10
	enemy_gold -= new_enemy_legions_created * 100

func calculate_score():
	var score = 0
	for tile in player_owned_tiles:
		var tile_data : TileData = tilemap.get_cell_tile_data(0, Vector2i(tile[0], tile[1]))
		var is_building: bool = tile_data.get_custom_data("building")
		if is_building:
			score += 10
		else:
			score += 5
	return score

#################################################################

func create_new_enemy_legion():
	var new_legion_position = null
	if enemy_gold >= 100 and enemy_owned_tiles.size() > enemy_taken_positions.values().size():
		for tile in enemy_owned_tiles:
			if tile not in enemy_taken_positions.values():
				print("New enemy legion")
				var new_legion_scene = preload("res://Objects/enemy_legion.tscn")
				var new_legion_instance = new_legion_scene.instantiate()
				enemy_legions.add_child(new_legion_instance)
				new_legion_position = tile
				new_legion_instance.set_legion_position(new_legion_position)
				small_map.all_enemy_legions.append(new_legion_instance)
				
				new_enemy_legions_created += 1
				calculate_gold()
				print("Enemy gold: " + str(enemy_gold))
				break
			else:
				print("No available tiles")
				break
	else:
		print("Not enough gold or no available tiles")


