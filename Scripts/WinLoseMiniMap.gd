extends Node

@onready var turns: int = 0
@onready var legion_controller = get_node("/root/Small_map/LegionController")
@onready var winlose_screen = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/WinLoseScreen")
@onready var winlose_screen_label = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/WinLoseScreen/WinLoseLabel")
@onready var winlose_screen_next = get_node("/root/Small_map/Camera2D/MiniMenuCanvasLayer/WinLoseScreen/NextButton")

@onready var ui_screen = get_node("/root/Small_map/UICanvasLayer")



func turn_small_map():
	turns += 1
	if turns > 10:
		if legion_controller.player_owned_tiles.size() > legion_controller.enemy_owned_tiles.size():
			winlose_screen.visible = true
			winlose_screen_label.text = "You Win!"
			ui_screen.visible = false
		if legion_controller.player_owned_tiles.size() < legion_controller.enemy_owned_tiles.size():
			winlose_screen.visible = true
			winlose_screen_label.text = "You Lose!"
			winlose_screen_next.visible = false
			ui_screen.visible = false
	elif legion_controller.enemy_owned_tiles.size() == 0 or legion_controller.enemy_taken_positions.size() == 0:
		winlose_screen.visible = true
		winlose_screen_label.text = "You Win!"
		ui_screen.visible = false
	elif legion_controller.player_owned_tiles.size() == 0 or legion_controller.taken_positions.size() == 0:
		winlose_screen.visible = true
		winlose_screen_label.text = "You Lose!"
		winlose_screen_next.visible = false
		ui_screen.visible = false


func _on_next_button_pressed():
	Score.score += legion_controller.calculate_score()
	get_tree().change_scene_to_file("res://Levels/small_map.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
