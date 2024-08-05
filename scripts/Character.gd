extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -500.0
@export var DOUBLE_JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite

var double_jumped : bool = false

func _ready() -> void:
	pass

func _process(delta : float) -> void:
	pass
	
func _on_sprite_animation_changed() -> void:
	pass
	
func _on_sprite_animation_finished() -> void:
	if sprite.animation == 'jump':
		sprite.play('fall')
	elif sprite.animation == 'doublejump':
		sprite.play('fall')

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if sprite.animation not in ['fall','jump','doublejump']:
			sprite.play('fall')
	else:
		if sprite.animation not in ['run','idle']:
			sprite.play('idle')
		double_jumped = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		if direction == -1:
			sprite.flip_h = true
		elif direction == 1:
			sprite.flip_h = false

		if sprite.animation not in ['run','jump','fall', 'doublejump']:
			sprite.play('run')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		if sprite.animation not in ['idle','jump','fall', 'doublejump']:
			sprite.play('idle')

	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprite.play('jump')
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and not double_jumped:
		sprite.play('doublejump')
		velocity.y += DOUBLE_JUMP_VELOCITY
		double_jumped = true
		
	move_and_slide()
