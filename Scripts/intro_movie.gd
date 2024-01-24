extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if exit button is pressed, go to main menu
	if Input.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://Levels/Menu.tscn")


func _on_video_stream_player_finished():
	# when video is finished, go to main menu
	get_tree().change_scene_to_file("res://Levels/Menu.tscn")
