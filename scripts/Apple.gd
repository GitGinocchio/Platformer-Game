extends Area2D


@onready var sprite = $AnimatedSprite2D

@export var Sprite_Frames : SpriteFrames = null
@export var Randomize : bool = false

const Collectables_Path = "res://resources/collectables/"

@onready var collectables = [
	preload('res://resources/collectables/apple.tres'),
	preload('res://resources/collectables/banana.tres'),
	preload('res://resources/collectables/cherrie.tres'),
	preload('res://resources/collectables/melon.tres'),
	preload('res://resources/collectables/orange.tres'),
	preload('res://resources/collectables/pineapple.tres'),
	preload('res://resources/collectables/strawberrie.tres'),
	preload('res://resources/collectables/wiki.tres')
]

func _ready() -> void:
	if Sprite_Frames and not Randomize:
		sprite.sprite_frames = Sprite_Frames
		sprite.play('idle')
	elif Randomize:
		sprite.sprite_frames = collectables.pick_random()
		sprite.play('idle')
	else:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"): sprite.play("collected")

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "collected":
		queue_free()
