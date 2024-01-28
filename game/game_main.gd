extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_to_boot()

func jump_to_boot():
	var level = GameData.now_level
	var boot := load("res://boot/boot"+String.num(level)+".tscn") as PackedScene
	get_tree().change_scene_to_packed(boot)
