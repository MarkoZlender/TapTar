extends Control

signal end_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# emits the end_turn signal
func _on_end_turn_button_pressed():
	end_turn.emit()
