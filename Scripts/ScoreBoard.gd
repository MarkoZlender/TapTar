extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/ScoreText.text = Score.load_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	self.queue_free()
