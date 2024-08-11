extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.

#ProjectSettings.get_setting("physics/2d/default_gravity")

@export var Sprite_Frames : SpriteFrames = null
@export var Randomize : bool = false

@onready var characters = [
	preload('res://resources/characters/mask_dude.tres'),
	preload('res://resources/characters/ninja_frog.tres'),
	preload('res://resources/characters/pink_man.tres'),
	preload('res://resources/characters/virtual_guy.tres')
]

@export var SPEED = 300.0

@export var JUMP_VELOCITY = -500.0
@export var DOUBLE_JUMP_VELOCITY = -500.0

@export var GRAVITY : int = 980

@export var WALL_SLIDE_GRAVITY : int = 200 #490 # GRAVITY / 2.0
#@export var WALL_SLIDE_DECELERATION = 500.0
@export var WALL_JUMP_HORIZONTAL_VELOCITY = 50.0
@export var WALL_JUMP_STICKNESS = 100.0
@export var MOVEMENT_AGAINST_WALL_COOLDOWN = 0.5

@onready var sprite = $Sprite
@onready var cooldown: Timer = $Cooldown
@onready var tree = get_tree()

var first_jumped = false
var double_jumped = false
var walljump_left = false
var walljump_right = false

@onready var spawn : Vector2 = sprite.global_position
@onready var current_spawn : Vector2 = spawn

func _ready() -> void:
	if Sprite_Frames and not Randomize:
		sprite.sprite_frames = Sprite_Frames
		sprite.play('idle')
	elif Randomize:
		sprite.sprite_frames = characters.pick_random()
		sprite.play('idle')
	else:
		queue_free()

func die() -> void:
	#sprite.play('hit')
	sprite.play('desappearing')

func set_spawn(position : Vector2) -> void:
	current_spawn = position

func respawn() -> void:
	sprite.play('appearing')
	global_position = current_spawn
	
func _on_sprite_animation_finished() -> void:
	if sprite.animation == 'appearing':
		sprite.play('idle')
	elif sprite.animation == 'desappearing':
		respawn()
	elif sprite.animation == 'jump':
		velocity.x = 0
		sprite.play('fall')
	elif sprite.animation == 'doublejump':
		velocity.x = 0
		sprite.play('fall')
		
func _on_cooldown_timeout() -> void:
	walljump_left = false
	walljump_right = false
	pass # Replace with function body.
		
func _physics_process(delta: float) -> void:
	if sprite.animation in ['appearing','desappearing', 'hit']: return
	
	if is_on_wall_only():
		if velocity.y < 0: 
			velocity.y = 0 #move_toward(velocity.y, 0, WALL_SLIDE_DECELERATION * delta)
		
		velocity.y += WALL_SLIDE_GRAVITY * delta
		
		if sprite.flip_h:
			walljump_left = true
			velocity.x -= WALL_JUMP_STICKNESS
		else:
			walljump_right = true
			velocity.x += WALL_JUMP_STICKNESS
		
		if sprite.animation not in ['walljump']:
			sprite.play('walljump')
		
		first_jumped = false
		double_jumped = false
	elif is_on_floor():
		if sprite.animation not in ['run','idle']:
			sprite.play('idle')

		walljump_right = false
		walljump_left = false
		
		first_jumped = false
		double_jumped = false
	else:
		velocity.y += GRAVITY * delta
		if sprite.animation not in ['fall','jump','doublejump']:
			sprite.play('fall')
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if direction == -1 and (!walljump_left or is_on_wall_only()):
			velocity.x = direction * SPEED
			sprite.flip_h = true
			walljump_right = false
	
		elif direction == 1 and (!walljump_right or is_on_wall_only()):
			velocity.x = direction * SPEED
			sprite.flip_h = false
			walljump_left = false
			
			
		if sprite.animation not in ['run','jump','fall', 'doublejump','walljump']:
			sprite.play('run')
	else:
		if sprite.animation not in ['jump','doublejump'] and not (walljump_left or walljump_right):
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if sprite.animation not in ['idle','jump','fall', 'doublejump','walljump']:
			sprite.play('idle')
	
	if Input.is_action_just_pressed("jump"):
		if not first_jumped and is_on_wall_only():
			velocity.x = WALL_JUMP_HORIZONTAL_VELOCITY * (1 if sprite.flip_h else -1)
			velocity.y = JUMP_VELOCITY
		
			
			if sprite.flip_h:
				walljump_left = true
			else:
				walljump_right = true
			
			sprite.flip_h = not sprite.flip_h
			
			first_jumped = true
			
			sprite.play('jump')
			cooldown.start(MOVEMENT_AGAINST_WALL_COOLDOWN)
		
		elif not double_jumped and is_on_wall_only():
			velocity.x = WALL_JUMP_HORIZONTAL_VELOCITY * (1 if sprite.flip_h else -1)
			velocity.y = JUMP_VELOCITY
		
			
			if sprite.flip_h:
				walljump_left = true
			else:
				walljump_right = true
			
			sprite.flip_h = not sprite.flip_h
			
			double_jumped = true
			
			sprite.play('jump')
			cooldown.start(MOVEMENT_AGAINST_WALL_COOLDOWN)

		elif not first_jumped and not is_on_floor():
			sprite.play('jump')
			velocity.y = JUMP_VELOCITY
			first_jumped = true

		elif not double_jumped and not is_on_floor():
			sprite.play('doublejump')
			velocity.y = DOUBLE_JUMP_VELOCITY
			double_jumped = true
		
		elif is_on_floor():
			sprite.play('jump')
			velocity.y = JUMP_VELOCITY
			first_jumped = true
		
	move_and_slide()
