extends Node

# 当前关卡
func _ready() -> void:
	_pri_to_level(GameData.now_level)
	GameSignal.new_level.connect(go_level)

func go_level(level: int):
	GameData.now_level=level
	GameData.put_data()
	_pri_to_level(level)

func _pri_to_level(now_level):
	var level: = load("res://level/level"+String.num(now_level)+".tscn") as PackedScene
	var no = level.instantiate()
	no.name = "level"
	var g = get_node("level")
	if g!=null:
		g.queue_free()
	add_child(no)

