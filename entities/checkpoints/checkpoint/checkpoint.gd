extends Area2D


@onready var checkpointPosition = $CheckpointPosition
@onready var sprite = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $CheckPointParticles

@export var NUM_EXPLOSIONS = 1

var explosions = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == 'flagOut':
		sprite.play('flagIdle')
		
func _on_check_point_particles_finished() -> void:
	if explosions < NUM_EXPLOSIONS:
		particles.emitting = true
		particles.restart()
		explosions+=1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and sprite.animation not in ['flagOut','flagIdle']:
		sprite.play('flagOut')
		body.set_spawn(checkpointPosition.global_position)
		
		particles.emitting = true
		particles.restart()
		explosions+=1
