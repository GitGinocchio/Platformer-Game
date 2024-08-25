extends StaticBody2D

@export var MinUpVelocity = 300
@export var MaxUpVelocity = 500
var playerbody : CharacterBody2D = null

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		playerbody = body
		body.first_jumped = true
	
func _on_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		playerbody = null
			
func _physics_process(delta: float) -> void:
	if playerbody:
		playerbody.set_velocity(Vector2(0,-randi_range(MinUpVelocity,MaxUpVelocity)))
		playerbody.move_and_slide()
