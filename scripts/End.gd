extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $WinParticles

@export var NUM_EXPLOSIONS = 3

var explosions = 0
var win = false

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play('idle')

func _on_win_particles_finished() -> void:
	get_tree().reload_current_scene()
	#if explosions <= NUM_EXPLOSIONS:
		#particles.emitting = true
		#particles.restart()
		#explosions+=1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not win:
		sprite.play('pressed')
		win = true
		
		particles.emitting = true
		particles.restart()
		explosions+=1
