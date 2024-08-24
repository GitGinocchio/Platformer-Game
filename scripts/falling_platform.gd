extends RigidBody2D

# Da rifare il codice con l'Animation Player

@export var despawn : bool = false

func _ready() -> void:
	pass
	
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shutdown" and despawn:
		$AnimationPlayer.play("despawn")


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("shutdown")
