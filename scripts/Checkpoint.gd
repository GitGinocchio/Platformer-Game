extends Area2D


@onready var checkpointPosition = $CheckpointPosition
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == 'flagOut':
		sprite.play('flagIdle')

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and sprite.animation not in ['flagOut','flagIdle']:
		sprite.play('flagOut')
		body.set_spawn(checkpointPosition.global_position)
		
