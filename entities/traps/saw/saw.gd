extends Path2D

@onready var path: PathFollow2D = $Path
@onready var sprite: AnimatedSprite2D = $Path/AnimatedSprite2D

@export var speed : float = 1.0

var direction = 1
	
func _physics_process(delta: float) -> void:
	path.progress += direction * speed
	if path.progress_ratio >= 1 or path.progress_ratio <= 0:
		direction = -direction
	

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and sprite.animation == 'on':
		body.call_deferred("die")
