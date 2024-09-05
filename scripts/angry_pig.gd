extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var L_RayCast: RayCast2D = $RayCasts/WallLeft
@onready var R_RayCast: RayCast2D = $RayCasts/WallRight
@onready var LD_RayCast: RayCast2D = $RayCasts/GroundLeftDown
@onready var RD_RayCast: RayCast2D = $RayCasts/GroundRightDown

@onready var PL_RayCast: RayCast2D = $RayCasts/PlayerLeft
@onready var PR_RayCast: RayCast2D = $RayCasts/PlayerRight
@onready var PT_RayCast: RayCast2D = $RayCasts/PlayerTop

@export var GRAVITY : int = 980
@export var speed : float = 50.0
@export var angry_speed : float = 150.0
@export var change_direction_cooldown : float = 0.5
@export var max_hit : int = 3

var direction = -1
var ontop = false
var angry = false
var n_hit = 0

func change_direction():
	direction = -direction
	sprite.flip_h = not sprite.flip_h

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('walk')
	
	
func _on_change_direction_cooldown_timeout() -> void:
	sprite.play('walk')
	change_direction()

func _on_triggered_area_body_entered(body: Node2D) -> void:
	sprite.play('run')
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation in ['hit1','hit2']:
		sprite.play('idle')
	
func _physics_process(delta: float) -> void:
	if direction == 1 and (R_RayCast.is_colliding() or (!RD_RayCast.is_colliding())) and sprite.animation not in ['hit1','hit2']:
		if $ChangeDirectionCooldown.is_stopped():
			$ChangeDirectionCooldown.start(change_direction_cooldown)
			sprite.play('idle')
	elif direction == -1 and (L_RayCast.is_colliding() or (!LD_RayCast.is_colliding())) and sprite.animation not in ['hit1','hit2']:
		if $ChangeDirectionCooldown.is_stopped():
			$ChangeDirectionCooldown.start(change_direction_cooldown)
			sprite.play('idle')
	
	if sprite.animation not in ['hit1','hit2']:
		if PR_RayCast.is_colliding():
			if direction == -1: change_direction()
			sprite.play('run')
			angry = true
		elif PL_RayCast.is_colliding():
			if direction == 1: change_direction()
			sprite.play('run')
			angry = true
		elif $TriggeredArea.has_overlapping_bodies():
			sprite.play('run')
			angry = true
		elif sprite.animation != 'idle':
			sprite.play('walk')
			angry = false
	
	if PT_RayCast.is_colliding() and not ontop and n_hit < max_hit:
		sprite.play('hit1')
		n_hit+=1
		ontop = true
	elif PT_RayCast.is_colliding() and not ontop and n_hit >= max_hit:
		sprite.play('hit2')
		ontop = true
	elif not PT_RayCast.is_colliding() and ontop:
		ontop = false
	
	if (RD_RayCast.is_colliding() and direction == 1) or (LD_RayCast.is_colliding() and direction == -1) and sprite.animation not in ['hit1','hit2']:
		velocity.x = direction * (speed if not angry else angry_speed)
	else:
		velocity.x = 0
	velocity.y += GRAVITY * delta
	move_and_slide()
