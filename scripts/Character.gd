extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.

#ProjectSettings.get_setting("physics/2d/default_gravity")
@export var SPEED = 300.0

@export var JUMP_VELOCITY = -500.0
@export var DOUBLE_JUMP_VELOCITY = -500.0

@export var GRAVITY : int = 980

@export var WALL_SLIDE_GRAVITY : int = 200 #490 # GRAVITY / 2.0
@export var WALL_SLIDE_DECELERATION = 500.0
@export var WALL_JUMP_HORIZONTAL_VELOCITY = 200.0


@onready var sprite = $Sprite

var double_jumped : bool = false
var wall_sticking : bool = false

func _ready() -> void:
	pass

func _process(delta : float) -> void:
	pass
	
func _on_sprite_animation_changed() -> void:
	pass
	
func _on_sprite_animation_finished() -> void:
	if sprite.animation == 'jump':
		velocity.x = 0
		sprite.play('fall')
	elif sprite.animation == 'doublejump':
		velocity.x = 0
		sprite.play('fall')

func _physics_process(delta: float) -> void:
	if is_on_wall_only():
		wall_sticking = true
		velocity.x = 0
		if velocity.y < 0: 
			velocity.y = 0 #move_toward(velocity.y, 0, WALL_SLIDE_DECELERATION * delta)
		else:
			velocity.y += WALL_SLIDE_GRAVITY * delta
		if sprite.animation not in ['walljump']:
			sprite.play('walljump')
	elif is_on_floor():
		if sprite.animation not in ['run','idle']:
			sprite.play('idle')
		wall_sticking = false
		double_jumped = false
	else:
		wall_sticking = false
		velocity.y += GRAVITY * delta
		if sprite.animation not in ['fall','jump','doublejump']:
			sprite.play('fall')
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		print(direction, wall_sticking, sprite.flip_h, velocity.x)
		
		if direction == -1:
			#if Input.is_action_just_pressed('jump'):
				#velocity.x = 0
			#else:
			velocity.x = direction * SPEED
			wall_sticking = false
			sprite.flip_h = true
	
		else: #direction == 1
			#if Input.is_action_just_pressed('jump'):
				#velocity.x = 0
			#else:
			velocity.x = direction * SPEED
			wall_sticking = false
			sprite.flip_h = false
				
		print(direction, wall_sticking, sprite.flip_h, velocity.x)

		if sprite.animation not in ['run','jump','fall', 'doublejump','walljump']:
			sprite.play('run')
	else:
		if sprite.animation not in ['jump','doublejump']:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if sprite.animation not in ['idle','jump','fall', 'doublejump','walljump']:
			sprite.play('idle')
			
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			sprite.play('jump')
			velocity.y = JUMP_VELOCITY
		elif not double_jumped:
			sprite.play('doublejump')
			velocity.y = DOUBLE_JUMP_VELOCITY
			double_jumped = true
		elif is_on_wall_only():
			velocity.x = 0
			
			velocity.x = WALL_JUMP_HORIZONTAL_VELOCITY * (1 if sprite.flip_h else -1)
			velocity.y = JUMP_VELOCITY
			
			sprite.flip_h = not sprite.flip_h
			wall_sticking = false
			double_jumped = false
			
			sprite.play('jump')
		
	move_and_slide()
