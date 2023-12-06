extends Control

@onready var legion_controller = get_node("/root/Small_map/LegionController")

@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null

@onready var animation_player = $SceneTransitionRect/AnimationPlayer
@onready var scene_transition_rect = $SceneTransitionRect

@onready var background = $Background
@onready var rng = RandomNumberGenerator.new()

@onready var attack_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_engaged_player_legion = legion_controller.get_current_engaged_player_legion()
	current_engaged_enemy_legion = legion_controller.get_current_engaged_enemy_legion()
	
	scene_transition_rect.visible = true
	animation_player.play_backwards("Fade")

	$EnemyLegionSprite.set_flip_h(true)
	
	$PlayerHealthLabel.text = str(current_engaged_player_legion.health)
	$EnemyHealthLabel.text = str(current_engaged_enemy_legion.health)



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

		var random_number = rng.randi_range(1, 3)
		current_engaged_enemy_legion.health -= random_number
		$EnemyHealthBar.value -= random_number
		$EnemyHealthLabel.text = str(current_engaged_enemy_legion.health)
		attack_counter += 1

		if current_engaged_enemy_legion.health <= 0:
			$EnemyHealthLabel.text = str(0)
			#current_engaged_enemy_legion.queue_free()
			animation_player.play_backwards("Fade_out")
	else:
		pass


func _on_end_turn_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($EnemyLegionSprite, "global_position", Vector2(1368,629), 0.1)
	tween.tween_property($EnemyLegionSprite, "global_position", Vector2(1587,629), 0.5)

	var random_number_enemy = rng.randi_range(1, 3)
	current_engaged_player_legion.health -= random_number_enemy
	$PlayerHealthBar.value -= random_number_enemy
	$PlayerHealthLabel.text = str(current_engaged_player_legion.health)
	attack_counter = 0

	if current_engaged_player_legion.health <= 0:
		$PlayerHealthLabel.text = str(0)
		#current_engaged_enemy_legion.queue_free()
		animation_player.play_backwards("Fade_out")
