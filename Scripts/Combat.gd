extends Control

@onready var legion_controller = get_node("/root/Small_map/LegionController")

@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null
@onready var Legion = preload("res://Scripts/legion.gd")

@onready var background = $Background


# Called when the node enters the scene tree for the first time.
func _ready():
	current_engaged_player_legion = legion_controller.get_current_engaged_player_legion()
	current_engaged_enemy_legion = legion_controller.get_current_engaged_enemy_legion()
	
	# if current_engaged_player_legion is legion:
	# 	add_child(legion.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
