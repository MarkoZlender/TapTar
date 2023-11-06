extends Node

@onready var taken_positions = Dictionary()
@onready var enemy_taken_positions = Dictionary()
@onready var selected_legions = Array()

@onready var player_owned_tiles = Array()
@onready var enemy_owned_tiles = Array()

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



