extends Control

@export var points := 30

var _save_game = SaveGame.new()
var character = Character.new()

var combat_skill_value = 0
var vitality_skill_value = 0
var hacking_skill_value = 0
var lockpicking_skill_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Points.text = str(points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_points():
	$Points.text = str(points - combat_skill_value - vitality_skill_value - hacking_skill_value - lockpicking_skill_value)

func _on_back_button_pressed():
	self.queue_free()

func set_character_stats():
	character.character_name = $NameInput.text
	character.combat = combat_skill_value
	character.vitality = vitality_skill_value
	character.hacking = hacking_skill_value
	character.lockpicking = lockpicking_skill_value
	_save_game.character = character
	_save_game.write_game()
	

func _on_start_button_pressed():
	set_character_stats()
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")


func _on_combat_skill_input_value_changed(value):
	combat_skill_value = value
	update_points()

func _on_vitality_skill_input_value_changed(value):
	vitality_skill_value = value
	update_points()

func _on_hacking_skill_input_value_changed(value):
	hacking_skill_value = value
	update_points()

func _on_lockpicking_skill_input_value_changed(value):
	lockpicking_skill_value = value
	update_points()
