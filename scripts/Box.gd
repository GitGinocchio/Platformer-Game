extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer

@export_enum("1","2","3") var BOX_TYPE = "1"
@export var STATIC : bool = false
@export var MAX_FALL: float = 150
@export var MAX_HIT: int = 1

var broken_box = preload("res://scenes/objects/box/broken_box.tscn")

var broken_box_tilesets = {
	"1" : preload("res://assets/Items/Boxes/Box1/Break.png"),
	"2" : preload("res://assets/Items/Boxes/Box2/Break.png"),
	"3" : preload("res://assets/Items/Boxes/Box3/Break.png")
}

var initial_position: Vector2
var current_hit: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = sprite.global_position
	
	if STATIC: freeze = true
	
	sprite.play("idle" + BOX_TYPE)

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "hit" + BOX_TYPE and current_hit >= MAX_HIT:
		animation.play("explosion")
	else:
		sprite.play("idle" + BOX_TYPE)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.name == "Character" and STATIC:
		current_hit+=1
		sprite.play("hit" + BOX_TYPE)
		
	elif body.name == "Environment":
		if (sprite.global_position.y - initial_position.y) > MAX_FALL:
			current_hit+=1
			sprite.play("hit" + BOX_TYPE)
		else:
			initial_position = sprite.global_position

func explode() -> void:
	var node = broken_box.instantiate()
	node.tileset = broken_box_tilesets[BOX_TYPE]
	add_child(node)
	
	sprite.visible = false
	collision.queue_free()
