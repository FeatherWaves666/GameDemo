extends Area2D

@onready var anim = get_node("AnimatedSprite2D")

func _ready():
	anim.play("Idle")

func _on_body_entered(body):
	if body.name == "Play":
		Game.Gold += 5
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 35), 0.35)
		tween.tween_property(self, "modulate:a", 0, 0.3)
		tween.tween_callback(queue_free)
