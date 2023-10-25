extends Control

signal legion_selected(selected: bool)

@onready var player_tile_map = $PlayerSelect/PlayerTileMap
@onready var player_select = $PlayerSelect
@onready var tilemap = current_tilemap

@export var current_tilemap: TileMap = null
@export var moved: bool = false
@export var legion_selection: bool
@export var legion_position: Vector2i
@export var neighbours: Array[Vector2i]


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	player_tile_map.hide()
	legion_position = current_tilemap.local_to_map(self.global_position)
	neighbours = current_tilemap.get_surrounding_cells(legion_position)
	legion_selection = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func movement():
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
						if legion_selection == true:
							self.global_position = tilemap.map_to_local(tile_mouse_position)
							legion_position = tilemap.local_to_map(self.global_position)
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

	if moved == true:
		player_tile_map.hide()

func _on_selected_toggled(button_pressed):
	legion_selected.emit(button_pressed)

func _on_legion_selected(selected):
	if selected && moved == false:
		legion_selection = true
		player_tile_map.show()

func set_end_turn():
	moved = false
	legion_selection = false
	player_select.button_pressed = false

func set_legion_position(new_legion_position: Vector2i):
	self.global_position = tilemap.map_to_local(position)
	legion_position = tilemap.local_to_map(self.global_position)

func _input(event):
	movement()
