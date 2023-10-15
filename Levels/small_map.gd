extends Node2D

var tilemap

var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = $GroundTiles
	set_process_input(true)
	#character = save_game.character
	#$TextureRect.texture = character.portrait
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		
		var mouse_position = get_global_mouse_position()
		
		var tile_mouse_position : Vector2i = tilemap.local_to_map(mouse_position)
		
		
		
		var tile_data : TileData = tilemap.get_cell_tile_data(0, tile_mouse_position)
		
		
		
		if tile_data:
			var tile_name = str(tile_data.get_custom_data("Tile_name"))
			print("tile mouse pos" + str(tile_mouse_position) + tile_name)
		else:
			print("NO TILE DATA!" + str(tile_mouse_position))
		

	
	
