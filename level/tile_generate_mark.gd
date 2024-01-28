class_name TileGenerateMark
extends Marker2D

@export var layer: int = 3 #干涉地图
@export var tile_code: String = "Jump"
@export var store: String = ""
@export var index: int = 0

func use_generate():
	LevelSignal.exchange_tile.emit(layer,global_position,tile_code,index,store)
