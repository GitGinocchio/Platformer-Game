extends Path2D

@onready var path: PathFollow2D = $Path
@onready var firetimer: Timer = %FireTimer
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var body: CharacterBody2D = %Body

const BeeBullet = preload('res://scenes/bullets/bee_bullet.tscn')

@export var X_offset : float = 10.0
@export var Y_offset : float = 10.0
@export var X_offset_speed : float = 0.3
@export var Y_offset_speed : float = 0.3

@export var Gravity : int = 980

@export var Speed : float = 0.5
@export var Fire_Rate = 1.5

var direction = 1
var offset = null
var fire = false
var died = false

func spawn_bullet() -> void:
	offset = null
	var Instance = BeeBullet.instantiate()
	Instance.position = Vector2(path.position.x,path.position.y + 15)
	add_child(Instance)

func _on_sprite_animation_finished() -> void:
	if sprite.animation == 'attack':
		sprite.play("idle")

func _on_fire_timer_timeout() -> void:
	if died: return
		
	%AnimationPlayer.play('shoot')
	if fire and not died: firetimer.start(Fire_Rate)
	
func _on_fire_area_body_entered(body: Node2D) -> void:
	fire = true
	if firetimer.is_stopped() and not died:
		firetimer.start(Fire_Rate)

func _on_fire_area_body_exited(body: Node2D) -> void:
	fire = false

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("Player"):
		died = true
		fire = false
		%AnimationPlayer.play("die")

func _physics_process(delta: float) -> void:
	if died:
		body.velocity.y += Gravity * delta
		body.move_and_slide()
		return
	
	if not offset:
		offset = Vector2(
			randf_range(-X_offset,X_offset),
			randf_range(-Y_offset,Y_offset)
		)
	else:
		path.v_offset = move_toward(path.v_offset, offset.y, Y_offset_speed)
		path.h_offset = move_toward(path.h_offset, offset.x, X_offset_speed)
		
		if abs(path.v_offset) >= abs(offset.y):
			offset = null
		elif abs(path.h_offset) >= abs(offset.x):
			offset = null
			
	path.progress += direction * Speed
	if path.progress_ratio >= 1 or path.progress_ratio <= 0:
		direction = -direction
		
	#body.move_and_slide()
