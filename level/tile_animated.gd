class_name TileAnimated
extends TileMap


## TileCodeIndex
## [source_id,x,y]
class TileCodeIndex:
	var source_id: int
	var cord: Vector2i
	var back_id: int = 0

var marked:= false
## map<code-index>,codeIndex
var tileCodeMap :Dictionary = {}
## map<layer-cord,id>
var snarioMap: Dictionary = {}
var intCollide := PlayerInt.new()

func _ready() -> void:
	load_atlas_sources()
	PlayerStats.int_tile.connect(int_collide)
	LevelSignal.exchange_tile.connect(exchange_tile)
	LevelSignal.clear_tile.connect(clear_tile)

## 导入TileSet的全部数据资源
func load_atlas_sources():
	var source_count = tile_set.get_source_count()
	for i in range(0,source_count):
		var sid = tile_set.get_source_id(i)
		var atsource := tile_set.get_source(sid) as TileSetAtlasSource
		var tile_count = atsource.get_tiles_count()
		for q in range(0,tile_count):
			var qid = atsource.get_tile_id(q)
			var cell = atsource.get_tile_data(qid,0)
			if cell!=null:
				var code = cell.get_custom_data("TileCode")
				var index = cell.get_custom_data("Index")
				if code!=null and code!="" and index!=null:
					var codeIndex = TileCodeIndex.new()
					codeIndex.cord=qid
					codeIndex.source_id=sid
					var rc = code+String.num(index)
					tileCodeMap[rc]=codeIndex
			var count = atsource.get_alternative_tiles_count(qid)
			for s in range(0,count):
				var aid = atsource.get_alternative_tile_id(qid,s)
				var acell = atsource.get_tile_data(qid,aid)
				var code = acell.get_custom_data("TileCode")
				var store = acell.get_custom_data("Store")
				var index = acell.get_custom_data("Index")
				store = store if store!=null else ""
				if code!=null and code!="" and index!=null:
					var codeIndex = TileCodeIndex.new()
					codeIndex.cord=qid
					codeIndex.source_id=sid
					codeIndex.back_id=aid
					var rc = code+String.num(index)+"/"+store
					tileCodeMap[rc]=codeIndex			
	print("导入完成。。。")

func _physics_process(delta: float) -> void:
	if marked:
		handle_tile_anim()
		marked=false

func markAnimated():
	marked=true

## 处理地图动画
func handle_tile_anim():
	var left = get_viewport_transform()
	var vec = left.get_origin() * -1
	var view_rect = get_viewport_rect()
	var start_po = vec
	var end_po = vec+view_rect.size
	var loc = to_local(start_po)
	var starti := local_to_map(loc)
	var endloc = to_local(end_po)
	var endti := local_to_map(endloc)
	for i in range(1,7):
		frame_tile_anim(starti,endti,i)

func frame_tile_anim(starti: Vector2i, endi: Vector2i, layer: int):
	var vec = Vector2i(0,0)
	for i in range(starti.x,endi.x+1):
		vec.x=i
		for j in range(starti.y,endi.y+1):
			vec.y=j
			var cell = get_cell_tile_data(layer,vec)
			if cell!=null:
				var tile_code = cell.get_custom_data("TileCode")
				if tile_code==null or tile_code=="":
					continue
				var auto_anim = cell.get_custom_data("AutoAnimation")
				var index = cell.get_custom_data("Index")
				if auto_anim:
					var frame:  = cell.get_custom_data("Frames") as PackedInt32Array
					var destIndex = 0
					for z in range(0,frame.size()):
						var dest = frame[z]
						if dest==index:
							destIndex=z
					destIndex+=1
					destIndex%=frame.size()
					index_title_anim(layer,vec,tile_code,frame[destIndex])

## 播放瓦片动画
func play_tile_anim(layer: int,veci: Vector2i, tile_code: String, animIndex: Array[int], loop: bool):
	pass

## 切换物品索引到新的索引片
func index_title_anim(layer: int,veci: Vector2i, tile_code: String, index: int):
	var rp = tile_code + String.num(index)
	if !tileCodeMap.has(rp):
		return
	var code_index = tileCodeMap[rp] as TileCodeIndex
	if code_index!=null:
		set_cell(layer,veci,code_index.source_id,code_index.cord)

func clear_tile(layer: int, veci: Vector2i):
	set_cell(layer,veci)

func int_collide(player: Player):
	intCollide.int_tile(player,self)

func exchange_tile(layer: int, pos: Vector2, tile_code: String, index: int, store: String=""):
	var loc = to_local(pos)
	var veci := local_to_map(loc)
	var rp=""
	if store!="":
		rp = tile_code + String.num(index) + "/" +store
	else:
		rp = tile_code + String.num(index)
	if !tileCodeMap.has(rp):
		print("不存在tile ",rp)
		return
	var code_index = tileCodeMap[rp] as TileCodeIndex
	if code_index!=null:
		set_cell(layer,veci,code_index.source_id,code_index.cord,code_index.back_id)		
