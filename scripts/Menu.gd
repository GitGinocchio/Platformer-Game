extends Control

@onready var background = $Background
@export var backgrounds = [
	preload("res://assets/Background/Blue.png"),
	preload("res://assets/Background/Brown.png"),
	preload("res://assets/Background/Gray.png"),
	preload("res://assets/Background/Green.png"),
	preload("res://assets/Background/Pink.png"),
	preload("res://assets/Background/Purple.png"),
	preload("res://assets/Background/Yellow.png")
]

func _ready() -> void:
	background.texture = backgrounds.pick_random()


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
