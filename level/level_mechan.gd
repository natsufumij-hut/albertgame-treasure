extends Node

@onready var bullets: = $bullets as Node2D
@onready var tricks := $Tricks

func _ready() -> void:
	LevelSignal.put_bullet.connect(put_bullet)
	LevelSignal.use_trick.connect(use_trick)

func put_bullet(bu: Node2D):
	bullets.add_child(bu)

func use_trick(id: String):
	var trick = tricks.get_node(id)
	if trick!=null:
		var mark = trick as TileGenerateMark
		mark.use_generate()
