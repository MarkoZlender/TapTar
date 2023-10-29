extends Control


@onready var all_legions = self.get_children()

@onready var taken_positions = Dictionary()
@onready var selected_legions = Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check_position(unit: Node, new_legion_position: Vector2i):
	taken_positions[unit] = new_legion_position
	print("Restricted coords: " + str(taken_positions))


		
