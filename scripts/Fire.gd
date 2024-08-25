extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var StartFireCooldown = 0.5
@export var FireDuration = 1

var playerbody : CharacterBody2D = null

func _ready() -> void:
	$fireCooldown.wait_time = StartFireCooldown
	$fireDuration.wait_time = FireDuration

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "hit":
		$fireCooldown.start()
		
func _on_fire_cooldown_timeout() -> void:
	$fireDuration.start()
	sprite.play("on")

func _on_fire_duration_timeout() -> void:
	sprite.play("off")

func _on_body_entered(body: Node2D) -> void:
	playerbody = body
	if sprite.animation == "off":
		sprite.play("hit")
	
func _on_body_exited(body: Node2D) -> void:
	playerbody = null

func _physics_process(delta: float) -> void:
	if sprite.animation == 'on' and playerbody:
		playerbody.die()
