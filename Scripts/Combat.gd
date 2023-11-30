extends Control

@onready var legion_controller = get_node("/root/Small_map/LegionController")

@onready var current_engaged_player_legion = null
@onready var current_engaged_enemy_legion = null

@onready var animation_player = $SceneTransitionRect/AnimationPlayer
@onready var scene_transition_rect = $SceneTransitionRect

@onready var background = $Background




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

func _input(event):
	if Input.is_action_pressed("exit"):
		animation_player.play_backwards("Fade_out")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Fade_out":
		self.queue_free()


func _on_attack_button_pressed():
	current_engaged_enemy_legion.health -= 1
	$EnemyHealthLabel.text = str(current_engaged_enemy_legion.health)
