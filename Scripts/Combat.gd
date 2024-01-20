extends Control

@onready var legion_controller = get_node("/root/Small_map/LegionController")
@onready var camera = get_node("/root/Small_map/Camera2D")
@onready var ui_canvas_layer = get_node("/root/Small_map/UICanvasLayer")
@onready var gold_label = get_node("/root/Small_map/UICanvasLayer/UI/GoldLabel")
@onready var background_music = get_node("/root/Small_map/BackgroundMusic")
@onready var sfx_player = $SFXPlayer



@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null

@onready var animation_player = $SceneTransitionRect/AnimationPlayer
@onready var scene_transition_rect = $SceneTransitionRect

@onready var background = $Background
@onready var rng = RandomNumberGenerator.new()

@onready var defend:bool = false

@onready var attack_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.set_enabled(false)
	ui_canvas_layer.set_visible(false)

	current_engaged_player_legion = legion_controller.get_current_engaged_player_legion()
	current_engaged_enemy_legion = legion_controller.get_current_engaged_enemy_legion()
	
	scene_transition_rect.visible = true
	animation_player.play_backwards("Fade")

	$EnemyLegionSprite.set_flip_h(true)
	
	$PlayerHealthLabel.text = str(current_engaged_player_legion.health)
	$EnemyHealthLabel.text = str(current_engaged_enemy_legion.health)

	$PlayerHealthBar.value = current_engaged_player_legion.health
	$EnemyHealthBar.value = current_engaged_enemy_legion.health

	print("Player health: "+str(current_engaged_player_legion.health))
	
	print("Owned positions before end of combat: "+str(legion_controller.player_owned_tiles))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$EnemyLegionSprite.play("idle")
	$PlayerLegionSprite.play("idle")

# func _input(event):
# 	if Input.is_action_pressed("exit"):
# 		animation_player.play_backwards("Fade_out")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Fade_out":
		self.queue_free()


func _on_attack_button_pressed():
	if attack_counter < 1:
		var tween = get_tree().create_tween()
		tween.tween_property($PlayerLegionSprite, "global_position", Vector2(600,629), 0.1)
		tween.tween_property($PlayerLegionSprite, "global_position", Vector2(381,629), 0.5)
		sfx_player.stream = load("res://Resources/Sound/SFX/lightning.ogg")
		sfx_player.play()

		var random_number = rng.randi_range(10, 20)
		current_engaged_enemy_legion.health -= random_number
		$EnemyHealthBar.value -= random_number
		$EnemyHealthLabel.text = str(current_engaged_enemy_legion.health)
		attack_counter += 1

		if current_engaged_enemy_legion.health <= 0:
			$EnemyHealthLabel.text = str(0)
			legion_controller.enemy_taken_positions.erase(current_engaged_enemy_legion)
			# if enemy legion is defeated, update player owned tiles
			if (current_engaged_player_legion.get_legion_position() not in legion_controller.player_owned_tiles):
				legion_controller.player_owned_tiles.append(current_engaged_player_legion.get_legion_position())
			
			
			legion_controller.enemy_owned_tiles.erase(current_engaged_enemy_legion.get_legion_position())

			current_engaged_enemy_legion.set_engaged(false)
			current_engaged_player_legion.set_engaged(false)

			current_engaged_enemy_legion.queue_free()

			legion_controller.set_current_engaged_enemy_legion(null)
			legion_controller.set_current_engaged_player_legion(null)

			legion_controller.check_taken_position()

			print("Owned positions after end of combat: "+str(legion_controller.enemy_owned_tiles))

			

			animation_player.play_backwards("Fade_out")

			camera.set_enabled(true)
			legion_controller.calculate_gold()
			gold_label.text = str(legion_controller.gold)
			ui_canvas_layer.set_visible(true)
			background_music.play()

	else:
		pass


func _on_end_turn_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($EnemyLegionSprite, "global_position", Vector2(1368,629), 0.1)
	tween.tween_property($EnemyLegionSprite, "global_position", Vector2(1587,629), 0.5)
	sfx_player.stream = load("res://Resources/Sound/SFX/bat-hit.ogg")
	sfx_player.play()


	$DefendingIcon.visible = false

	var random_number_enemy = rng.randi_range(10, 20)
	
	# if defend is true, enemy legion deals half damage
	if defend:
		random_number_enemy = int(random_number_enemy / 2)

	current_engaged_player_legion.health -= random_number_enemy
	$PlayerHealthBar.value -= random_number_enemy
	$PlayerHealthLabel.text = str(current_engaged_player_legion.health)
	attack_counter = 0
	defend = false

	if current_engaged_player_legion.health <= 0:
		$PlayerHealthLabel.text = str(0)
		legion_controller.taken_positions.erase(current_engaged_player_legion)

		if (current_engaged_enemy_legion.get_legion_position() not in legion_controller.enemy_owned_tiles):
			legion_controller.enemy_owned_tiles.append(current_engaged_enemy_legion.get_legion_position())

		legion_controller.player_owned_tiles.erase(current_engaged_player_legion.get_legion_position())
		

		current_engaged_player_legion.set_engaged(false)
		current_engaged_enemy_legion.set_engaged(false)

		current_engaged_player_legion.queue_free()
		
		# update enemy knowledge of player legions on player legion deletion
		current_engaged_enemy_legion.player_legions = get_node("/root/Small_map/Legions").get_children()

		legion_controller.set_current_engaged_enemy_legion(null)
		legion_controller.set_current_engaged_player_legion(null)

		legion_controller.check_taken_position()

		print("Owned positions after end of combat: "+str(legion_controller.player_owned_tiles))

		
		legion_controller.calculate_gold()
		gold_label.text = str(legion_controller.gold)
		ui_canvas_layer.set_visible(true)

		animation_player.play_backwards("Fade_out")
		camera.set_enabled(true)
		background_music.play()


func _on_defend_button_toggled(button_pressed):
	if button_pressed:
		defend = true
		$DefendingIcon.visible = true
		sfx_player.stream = load("res://Resources/Sound/SFX/equipmentclicks.wav")
		sfx_player.play()
	else:
		defend = false
		$DefendingIcon.visible = false
		sfx_player.stream = load("res://Resources/Sound/SFX/equipmentclicks.wav")
		sfx_player.play()
