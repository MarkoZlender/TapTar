extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/ScoreText.text = Score.load_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# go back to the main menu when the button is pressed
func _on_button_pressed():
	self.queue_free()
