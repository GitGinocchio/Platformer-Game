extends RigidBody2D

var cankill = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("Player") and cankill:
		body.die()
		
	elif body is TileMapLayer:
		cankill = false
		$AnimationPlayer.play("despawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
