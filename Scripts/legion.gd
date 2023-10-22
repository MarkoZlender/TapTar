extends Control

signal legion_selected(selected: bool)
@onready var player_tile_map = $PlayerSelect/PlayerTileMap

@onready var player_select = $PlayerSelect




# Called when the node enters the scene tree for the first time.
func _ready():
	#player_select.global_position = player_tile_map.map_to_local(Vector2i(1,0))
	#player_select.global_position = player_tile_map.map_to_local(Vector2i(1,0))
	#self.global_position = player_tile_map.map_to_local(Vector2i(1,0))
	player_tile_map.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_selected_toggled(button_pressed):
	if button_pressed == true:
		player_tile_map.show()
	else:
		player_tile_map.hide()
	legion_selected.emit(button_pressed)
