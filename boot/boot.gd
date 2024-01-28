extends Node

var manage := preload("res://game/game_manager.tscn")

func start():
	get_tree().change_scene_to_packed(manage)

func exit():
	get_tree().quit()
