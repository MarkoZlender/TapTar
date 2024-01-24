extends Control

signal legion_selected(selected: bool)

@onready var player_tile_map = $PlayerSelect/PlayerTileMap
@onready var player_select = $PlayerSelect
@onready var tilemap = current_tilemap
@onready var animated_sprite = $ PlayerSelect/AnimatedPlayerSprite
@onready var sfx_player = get_node("/root/Small_map/SFXPlayer")
@onready var legion_controller = get_node("/root/Small_map/LegionController")
@onready var health = 50
@onready var engaged = false


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
	current_tilemap = get_node("/root/Small_map/GroundTiles")
	tilemap = current_tilemap
	legion_position = current_tilemap.local_to_map(self.global_position)
	neighbours = current_tilemap.get_surrounding_cells(legion_position)
	legion_selection = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite.play("idle")
	

func movement():
	# check if left mouse button is pressed
	if Input.is_action_just_pressed("left_click"):
		
		# get global mouse position
		var mouse_position = get_global_mouse_position()
		# convert global mouse position to local mouse position
		var tile_mouse_position : Vector2i = tilemap.local_to_map(mouse_position)
		
		# get custom data from tilemap
		var tile_data : TileData = tilemap.get_cell_tile_data(0, tile_mouse_position)
		
		# if tile data is not null, if tile exists
		if tile_data:
			# get bool for walkable condition from tile data
			var tile_wakable: bool = tile_data.get_custom_data("walkable")
			
			if tile_wakable:
				if moved == true:
					pass
				else:
					if (tile_mouse_position in neighbours) and (tile_mouse_position not in legion_controller.taken_positions.values()):
						if legion_selection == true:

							play_animation(tilemap.map_to_local(tile_mouse_position))
							new_position = tilemap.map_to_local(tile_mouse_position)
							legion_position = tilemap.local_to_map(new_position)
							neighbours = tilemap.get_surrounding_cells(legion_position)
							moved = true
							
							
							play_sound_effect()
							# append legion position to taken positions array
							legion_controller.check_player_owned_tiles(legion_position)
							# after moving remove legion selection from selected_legions array
							legion_controller.selected_legions.clear()
						else:
							pass
					else:
						pass
		else:
			pass

	if moved == true:
		player_tile_map.hide()
		legion_selection = false
		player_select.button_pressed = false
		legion_controller.check_position(self, legion_position)
		legion_controller.calculate_gold()
		
	


func play_animation(vTarget):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", vTarget, 0.5)

	if (tilemap.local_to_map(vTarget).x) < (legion_position.x):
		$PlayerSelect/AnimatedPlayerSprite.set_flip_h(true)
	if (tilemap.local_to_map(vTarget).x) > (legion_position.x):
		$PlayerSelect/AnimatedPlayerSprite.set_flip_h(false)

func play_sound_effect():
	sfx_player.stream = load("res://Resources/Sound/SFX/move.wav")
	sfx_player.play()

func _on_selected_toggled(button_pressed):
	if button_pressed:
		legion_controller.selected_legions.append(self)
	else:
		legion_controller.selected_legions.erase(self)
		player_tile_map.hide()
	legion_selected.emit(button_pressed)

func _on_legion_selected(selected):
	if (selected and moved == false) and legion_controller.selected_legions.size() < 2:
		legion_selection = true
		player_tile_map.show()

# set legion properties on end turn
func set_end_turn():
	moved = false
	legion_selection = false
	player_select.button_pressed = false
	

func set_legion_position(new_legion_position: Vector2i):
	self.global_position = tilemap.map_to_local(new_legion_position)
	legion_position = tilemap.local_to_map(self.global_position)
	neighbours = tilemap.get_surrounding_cells(legion_position)
	legion_controller.check_position(self, legion_position)

func set_engaged(engaged_value: bool):
	self.engaged = engaged_value
	

func set_selected(selected: bool):
	legion_selection = selected

func get_legion_position():
	return legion_position

func get_neighbours():
	return neighbours

# enable input based on events
func _input(event):
	movement()
