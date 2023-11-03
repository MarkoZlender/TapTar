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
@export var old_legion_position: Vector2i
@export var new_position: Vector2i



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
		#print("taken positions " + str(LegionController.taken_positions))
		#print("restricted coords " + str(SmallMap.taken_positions))
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
					pass
					#print("legion already moved")
				else:
					if (tile_mouse_position in neighbours) and (tile_mouse_position not in LegionController.taken_positions.values()):
						if legion_selection == true:
							# animation #########################################
							var tween = get_tree().create_tween()
							tween.tween_property(self, "global_position", tilemap.map_to_local(tile_mouse_position), 0.5)
							######################################################
							new_position = tilemap.map_to_local(tile_mouse_position)
							legion_position = tilemap.local_to_map(new_position)
							neighbours = tilemap.get_surrounding_cells(legion_position)
							moved = true
							# append legion position to taken positions array
							if legion_position not in LegionController.player_owned_tiles:
								LegionController.player_owned_tiles.append(legion_position)
							else:
								pass

							# after moving remove legion selection from selected_legions array
							LegionController.selected_legions.clear()
						else:
							pass
							#print("legion not selected")
					else:
						pass
						#print("tile not a neighbour")
		else:
			pass
			#print("NO TILE DATA!" + str(tile_mouse_position))

	if moved == true:
		player_tile_map.hide()
		legion_selection = false
		player_select.button_pressed = false
		LegionController.check_position(self, legion_position)
		

func _on_selected_toggled(button_pressed):
	if button_pressed:
		LegionController.selected_legions.append(self)
	else:
		LegionController.selected_legions.erase(self)
	#print("Selected legions: " + str(LegionController.selected_legions))
	legion_selected.emit(button_pressed)

func _on_legion_selected(selected):
	#print("Selected legions: " + str(SmallMap.selected_legions))
	if (selected and moved == false) and LegionController.selected_legions.size() < 2:
		legion_selection = true
		player_tile_map.show()

func set_end_turn():
	moved = false
	legion_selection = false
	player_select.button_pressed = false

func set_legion_position(new_legion_position: Vector2i):
	self.global_position = tilemap.map_to_local(new_legion_position)
	legion_position = tilemap.local_to_map(self.global_position)
	neighbours = tilemap.get_surrounding_cells(legion_position)
	LegionController.check_position(self, legion_position)

func set_selected(selected: bool):
	legion_selection = selected

func get_legion_position():
	return legion_position

func _input(event):
	movement()
