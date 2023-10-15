extends Control

@onready var tilemap = $Control3/GroundTiles

var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	character = save_game.character
	$Control/TextureRect.texture = character.portrait

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		
		var mouse_position = get_global_mouse_position()
		
		var tile_mouse_position : Vector2i = tilemap.local_to_map(mouse_position)
		
		var tile_data : TileData = tilemap.get_cell_tile_data(0, tile_mouse_position)
		var tile_data2 : TileData = tilemap.get_cell_tile_data(1, tile_mouse_position)
		
		var atlas_coords: Vector2i = Vector2i(0, 2)
		
		# https://www.reddit.com/r/godot/comments/13k98b0/how_do_i_use_set_cell/
		# https://www.youtube.com/watch?v=PSEPHO8ukjI
		
		if tile_data:
			var tile_name = str(tile_data.get_custom_data("Tile_name"))
			print("tile mouse position: " + str(tile_mouse_position) + "\n" + tile_name)
		else:
			print("NO TILE DATA!" + str(tile_mouse_position))

		if tile_data2:
			var tile_name2 = str(tile_data2.get_custom_data("Tile_name"))
			print("tile mouse position: " + str(tile_mouse_position) + "\n" + tile_name2)
			tilemap.set_cell(1, tile_mouse_position + Vector2i.DOWN, 1, atlas_coords)
		else:
			print("NO TILE DATA!" + str(tile_mouse_position))
