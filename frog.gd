extends CharacterBody2D

var player

var SPEED = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false

@onready var anim = get_node("AnimatedSprite2D")

func _ready(): # 空闲时间为idle 
	anim.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if chase == true:
		if anim.animation != "Death":
			anim.play("Jump")		
		player = get_node("../../Player/Play")
		var direction = (player.global_position - self.global_position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
			velocity.x = direction.x * SPEED
		elif direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
			velocity.x = direction.x * SPEED
	else:
		if anim.animation != "Death":
			anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Play":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Play":
		chase = false

func _on_player_death_body_entered(body):
	if body.name == "Play":
		
		death()
	
func _on_player_collision_body_entered(body):
	if body.name == "Play":
		Game.playerHP -= 3
		death()

func death():
	Game.Gold += 5
	Utils.saveGame()
	chase = false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()

