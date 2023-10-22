extends Control

@onready var tilemap = $GroundTiles
@onready var legion = $GroundTiles/legion

var moved: bool = false
var legion_position: Vector2i
var neighbours
var legion_selected: bool

var save_game = SaveGame.load_game() as SaveGame
var character = Character.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	character = save_game.character
	$Control/TextureRect.texture = character.portrait
	
	legion.global_position = tilemap.map_to_local(Vector2i(1,0))
	legion_position = tilemap.local_to_map(legion.global_position)
	neighbours = tilemap.get_surrounding_cells(legion_position)
	legion_selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		
		var mouse_position = get_global_mouse_position()
		
		var tile_mouse_position : Vector2i = tilemap.local_to_map(mouse_position)
		

		var tile_data : TileData = tilemap.get_cell_tile_data(0, tile_mouse_position)
		var tile_data2 : TileData = tilemap.get_cell_tile_data(1, tile_mouse_position)
		
		
		if tile_data:
			var tile_name = str(tile_data.get_custom_data("Tile_name"))
			var tile_wakable: bool = tile_data.get_custom_data("walkable")
			print("tile mouse position: " + str(tile_mouse_position) + "\n" + tile_name)
			if tile_wakable:
				if moved == true:
					print("legion already moved")
				else:
					if tile_mouse_position in neighbours:
						if legion_selected == true:
							legion.global_position = tilemap.map_to_local(tile_mouse_position)
							legion_position = tilemap.local_to_map(legion.global_position)
							neighbours = tilemap.get_surrounding_cells(legion_position)
							moved = true
							
						else:
							print("legion not selected")
					else:
						print("tile not a neighbour")
				
		else:
			print("NO TILE DATA!" + str(tile_mouse_position))

		if tile_data2:
			var tile_name2 = str(tile_data2.get_custom_data("Tile_name"))
			print("tile mouse position: " + str(tile_mouse_position) + "\n" + tile_name2)
		else:
			print("NO TILE DATA!" + str(tile_mouse_position))


func _on_end_turn_button_pressed():
	moved = false
	legion_selected = false

func _on_legion_legion_selected(selected):
	legion_selected = true
	if selected:
		print("legion selected")
		#for neighbour in neighbours:
			#tilemap.set_cell(0, neighbour, tilemap.get_cell_source_id(0, neighbour, false), Vector2i(2,2), 0)
	print("legion position" + str(legion_position))
	print(str(neighbours))
