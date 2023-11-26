extends Node

@onready var taken_positions = Dictionary()
@onready var enemy_taken_positions = Dictionary()
@onready var selected_legions = Array()

@onready var player_owned_tiles = Array()
@onready var enemy_owned_tiles = Array()

@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null

@onready var sfx_player = get_node("/root/Small_map/SFXPlayer")


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
	else:
		pass

func check_enemy_owned_tiles(taken_position):
	if taken_position not in enemy_owned_tiles:
		enemy_owned_tiles.append(taken_position)
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
		if taken_positions[legion] == tile_coord:
			return legion

func get_enemy_engaged_legion(tile_coord):
	for legion in enemy_taken_positions:
		if enemy_taken_positions[legion] == tile_coord:
			return legion

func get_current_engaged_player_legion():
	return current_engaged_player_legion

func get_current_engaged_enemy_legion():
	return current_engaged_enemy_legion

func check_engagement():
	for tile_coord in player_owned_tiles:
		if tile_coord in enemy_owned_tiles:
			current_engaged_player_legion = get_player_engaged_legion(tile_coord)
			current_engaged_enemy_legion = get_enemy_engaged_legion(tile_coord)
			play_sound_effect()
			var combat_scene = preload("res://Levels/Combat.tscn")
			var combat_scene_instance = combat_scene.instantiate()
			add_child(combat_scene_instance)

func play_sound_effect():
	sfx_player.stream = load("res://Resources/Sound/SFX/flame-big.ogg")
	sfx_player.play()


