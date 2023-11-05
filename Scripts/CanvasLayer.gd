extends CanvasLayer
@onready var line_2d = get_node("/root/Small_map/CanvasLayer/Line2D")
@export var line_2d_points:PackedVector2Array = PackedVector2Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_draw()

func _draw():
	line_2d.points = line_2d_points
