extends Control

@export var points := 30

var save_system = SaveSystem.new()
var character = Character.new()

var martial_prowess_skill_value = 0
var intelect_skill_value = 0
var charisma_skill_value = 0
var cunning_skill_value = 0

var portraits = ["res://Resources/Images/portrait1.jpg", "res://Resources/Images/portrait2.jpg", "res://Resources/Images/portrait3.jpg"]
var portrait_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Labels/Points.text = str(points)
	$Portrait.texture = load(portraits[portrait_index])
	add_map_menu_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_points():
	$Labels/Points.text = str(points - martial_prowess_skill_value - charisma_skill_value - intelect_skill_value - cunning_skill_value)

func _on_back_button_pressed():
	self.queue_free()

func set_character_stats():
	character.character_name = $NameInput.text
	character.martial_prowess = martial_prowess_skill_value
	character.intellect = intelect_skill_value
	character.charisma = charisma_skill_value
	character.cunning = cunning_skill_value
	character.portrait = $Portrait.texture
	save_system.save_game.character = character
	save_system.save_game.write_game()
	

func _on_start_button_pressed():
	set_character_stats()
	get_tree().change_scene_to_file(character.map)


func _on_next_button_pressed():
	portrait_index += 1
	if portrait_index > portraits.size()-1:
		portrait_index = 2
		$Portrait.texture = load(portraits[portrait_index])
	else:
		$Portrait.texture = load(portraits[portrait_index])


func _on_previous_button_pressed():
	portrait_index -= 1
	if portrait_index < 0:
		portrait_index = 0
		$Portrait.texture = load(portraits[portrait_index])
	else:
		$Portrait.texture = load(portraits[portrait_index])

func add_map_menu_items():
	$MapSelect.add_item("Small")
	$MapSelect.add_item("Normal")
	$MapSelect.add_item("Large")


func _on_map_select_item_selected(index):
	if index == 0:
		character.map = "res://Levels/small_map.tscn"
	elif index == 1:
		character.map = "res://Levels/normal_map.tscn"
	elif index == 2:
		character.map = "res://Levels/large_map.tscn"
	else:
		OS.alert("Map file not found!", "Notification")
		get_tree().quit()


# skill allocation

func _on_martial_prowess_skill_input_value_changed(value):
	martial_prowess_skill_value = value
	update_points()

func _on_intellect_skill_input_value_changed(value):
	intelect_skill_value = value
	update_points()


func _on_cunning_skill_input_value_changed(value):
	cunning_skill_value = value
	update_points()


func _on_charisma_skill_input_value_changed(value):
	charisma_skill_value = value
	update_points()
