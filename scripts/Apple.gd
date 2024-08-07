extends Area2D


@onready var sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body.is_in_group("Player"): sprite.play("collected")

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "collected":
		queue_free()
