extends Area2D

enum Direction { Vertical, Horizontal }

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


@export var direction: Direction = Direction.Vertical
@export var Force: float = -700

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == Direction.Horizontal and Force < 0:
		rotation_degrees = -90
	elif direction == Direction.Horizontal:
		rotation_degrees = 90
	elif direction == Direction.Vertical and Force > 0:
		rotation_degrees = 180
	else:
		rotation_degrees = 0
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "hit":
		queue_free()

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		print(body.velocity)
		body.velocity = Vector2(0,0)
		print(body.velocity)
		if direction == Direction.Vertical:
			body.velocity.y = Force
		else:
			body.velocity.x = Force
			
		body.move_and_slide()
		sprite.play("hit")
