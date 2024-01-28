extends Node

# 当前关卡
func _ready() -> void:
	GameData.load_data()
	GameData.sys_data()
	_pri_to_level(GameData.now_level)
	GameSignal.new_level.connect(go_level)
	GameSignal.level_reload.connect(reload_level)

func go_level(level: int):
	GameData.now_level=level
	GameData.put_data()
	_pri_to_level(level)

func reload_level():
	GameData.load_data()
	GameData.sys_data()
	_pri_to_level(GameData.now_level)

func _pri_to_level(now_level):
	var level: = load("res://level/level"+String.num(now_level)+".tscn") as PackedScene
	var no = level.instantiate()
	no.add_to_group("level")
	var trr = get_tree().get_nodes_in_group("level")
	for n in trr:
		n.queue_free()
	add_child(no)

