extends Area2D

enum Direction { Vertical, Horizontal }

@export var direction: Direction = Direction.Vertical
@export var Force: float = -300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == Direction.Horizontal and Force > 0:
		rotation_degrees = -90
	elif direction == Direction.Horizontal:
		rotation_degrees = 90
	elif direction == Direction.Vertical and Force > 0:
		rotation_degrees = 180
	else:
		rotation_degrees = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "hit":
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if direction == Direction.Vertical:
			body.velocity.y = Force
		else:
			body.velocity.x = Force
		$AnimatedSprite2D.play("hit")
	
	pass # Replace with function body.
