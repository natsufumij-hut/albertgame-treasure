extends Node

var save_path = "user://save_game.json"
const default_asset = { "hp":3,"hp_max":3,"Coin":0,"Key":0,"Mashroom":0,"Bomb":0,"Tai":0 }
# 当前关卡
var now_level := 1
var asset: = {}

func _ready() -> void:
	load_data()
	GameSignal.new_level.connect(put_data)

func load_data():
	if !FileAccess.file_exists(save_path):
		set_asset(default_asset)
		return
	var file := FileAccess.open(save_path, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict := json.get_data() as Dictionary
	now_level=save_dict["now_level"] as int
	if save_dict.has("asset"):
		asset=save_dict["asset"]
	else:
		asset=default_asset

func put_data():
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	# JSON doesn't support many of Godot's types such as Vector2.
	var save_dict = {
		"now_level": now_level,
		"asset": asset
	}
	file.store_line(JSON.stringify(save_dict))

func set_asset(ass: Dictionary):
	for n in ass:
		self.asset[n]=ass[n]

func sys_data():
	var asset = asset
	for n: String in asset:
		PlayerAsset.update_asset.emit(n,asset[n])
	var hp = asset.get("hp",3)
	var hpmax = asset.get("hp_max",3)
	PlayerStats.hp_max=hpmax
	PlayerStats.hp=hp
	PlayerAsset.syn_asset(asset)
	
