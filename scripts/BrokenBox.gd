extends Node2D

var tileset: Texture2D = preload("res://assets/Items/Boxes/Box1/Break.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TopLeftPiece/Sprite2D.texture.atlas = tileset
	$TopRightPiece/Sprite2D.texture.atlas = tileset
	$DownLeftPiece/Sprite2D.texture.atlas = tileset
	$DownRightPiece/Sprite2D.texture.atlas = tileset
	
	$AnimationPlayer.play("explosion")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
