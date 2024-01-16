extends Node

@onready var turns: int = 0
@onready var legion_controller = get_node("/root/Small_map/LegionController")


func turn_small_map():
    turns += 1
    if turns > 20 and legion_controller.player_owned_tiles.size() > legion_controller.enemy_owned_tiles.size():
        
        