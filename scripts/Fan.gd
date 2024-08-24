extends StaticBody2D


@export var VelocityPerSecond = 500
var playerbody : CharacterBody2D = null

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		playerbody = body
	
func _on_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		playerbody = null
			
func _physics_process(delta: float) -> void:
	if playerbody:
		playerbody.set_velocity(Vector2(0,-VelocityPerSecond))
		playerbody.move_and_slide()
