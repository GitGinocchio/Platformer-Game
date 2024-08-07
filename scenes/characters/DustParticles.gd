extends GPUParticles2D

@onready var character = $'..'

var last_animation

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var current_animation = character.sprite.animation
	var direction = character.sprite.flip_h
	
	if current_animation != last_animation:
		if current_animation == 'idle' and last_animation == 'fall':
			one_shot = true
			emitting = true
			restart()
		elif current_animation == 'run' and last_animation == 'idle':
			emitting = true
			one_shot = true
			restart()
	else:
		if current_animation == 'run':
			if one_shot:
				one_shot = false
			if not emitting:
				emitting = true
	
	last_animation = current_animation


func _on_finished() -> void:
	pass # Replace with function body.
