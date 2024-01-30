class_name PlayerCollide

## 处理玩家与地图Tile的碰撞
## 处理地图三层
## 第0层 地形 【无检测】
## 第1层 装饰（草、石头）
## 第2层 陷阱（荆棘Crons、尖刺Stine）
## 第3层 干涉地形（弹跳台Jump、水中Water、隐藏云/丛林Hide）
## 第4层 可收集道具（金币Coin、钥匙Key、炸弹Bomb、星星Star【添加生命值上限】、蘑菇Mashroom【回复生命值】、钻石Tai【暂时无敌状态】）
## 第5层 可交互道具（旗帜Flag、拨动开关Switch、按钮开关Button、门Door）
## 第6层 干涉形道具（剧情箱Snario、掉宝箱Drop【掉落物品】）
## 地图代码 Type/Index1

enum {
	TERRIAN,
	DECORATE,
	WANA,
	PUSH_TERRIAN,
	COLLECT_ITEM,
	INT_ITEM,
	PUSH_ITEM
}

const SPECIAL_COLLECT_ITEM : = { "Star": true,"Blade":true }
const TAKARA_BOXS := ["Star", "Coin", "Key/Yellow","Key/Red","Key/Blue","Key/Green"]
##map<layer+cord,id>
var push_store_dict := {}
var int_and_push: Dictionary = {}
var trick_pos: Dictionary = {}

## 处理地图碰撞
func handle_collide(player: Player,collision: KinematicCollision2D):
	int_and_push.clear()
	var ob := collision.get_collider() as Node2D
	var ps = collision.get_position()
	var level := ob as TileMap
	var loc = level.to_local(ps)
	var veci: Vector2i= level.local_to_map(loc)
	var count = level.get_layers_count()
	for i in range(1,7):
		var cell = level.get_cell_tile_data(i,veci)
		if cell!=null:
			var code = cell.get_custom_data("TileCode")
			if code!=null and code!="":
				manage_collide(i,player,veci,cell,collision)

## 无地图碰撞
func none_collide(player: Player):
	int_and_push.clear()

## 转发碰撞管理
func manage_collide(layer: int, player: Player,veci: Vector2i,cell: TileData, collision: KinematicCollision2D):
	match layer:
		WANA:
			handle_wana(layer,veci,player,cell,collision)
		COLLECT_ITEM:
			handle_collect_item(layer,veci,player,cell,collision)
		PUSH_TERRIAN:
			handle_push_terrian(layer,veci,player,cell,collision)
		PUSH_ITEM:
			handle_push_item(layer,veci,player,cell,collision)

## WANA
func handle_wana(layer: int,veci: Vector2i,player: Player, cell: TileData, collision: KinematicCollision2D):
	var code = cell.get_custom_data("TileCode")
	print("wana ",code)
	player.go_attack(1)

## COLLECT_ITEM
func handle_collect_item(layer:int,veci: Vector2i,player: Player, cell: TileData, collision: KinematicCollision2D):
	var code = cell.get_custom_data("TileCode")
	var level := collision.get_collider() as TileAnimated
	level.clear_tile(layer,veci)
	player.velocity=player.current_frame_velocity
	if SPECIAL_COLLECT_ITEM.has(code):
		handle_special_collect_item(codeType(code),player)
	else:
		var cType = codeType(code)
		player.collect_hand(cType)
		PlayerAsset.put_asset(cType,1)

## CodeType/CodeName
func codeType(code: String) -> String:
	if code.contains("/"):
		var s = code.split("/")
		return s[0]
	else:
		return code

func handle_special_collect_item(code: String, player: Player):
	match code:
		"Star":
			PlayerStats.push_heart(1)
		"Blade":
			GameSignal.found_blade.emit()

## 处理干涉形地形
func handle_push_terrian(layer:int,veci: Vector2i,player: Player, cell: TileData, collision: KinematicCollision2D):
	var code = cell.get_custom_data("TileCode")
	var level := collision.get_collider() as TileAnimated
	int_and_push["push_terrian"]=code
	match code:
		"Jump":
			handle_jump(player)

func handle_jump(player: Player):
	if player.current_frame_velocity.y>0:
			player.go_big_jump()

## 处理干涉道具
func handle_push_item(layer: int, veci: Vector2i, player: Player,cell: TileData, collision: KinematicCollision2D):
	var code = cell.get_custom_data("TileCode")
	var level := collision.get_collider() as TileAnimated
	if player.current_frame_velocity.y>=0:
		return
	var index = cell.get_custom_data("Index")
	player.velocity.y=10
	player.tiled()
	if index==2:
		print("砸碎这个方块,生成对应的东西")
		level.clear_tile(layer,veci)
		var store = pop_item_store(cell,layer,veci)
		handle_push_item_generate(player,COLLECT_ITEM,veci,code,cell,level,store)
	else:
		level.index_title_anim(layer,veci,code,index+1)
		push_item_store(cell,layer,veci)

func push_item_store(cell: TileData,layer: int, coord: Vector2i):
	var pid = String.num(layer)+String.num(coord.x)+String.num(coord.y)
	var store = cell.get_custom_data("Store")
	if !push_store_dict.has(pid):
		push_store_dict[pid]=store

func pop_item_store(cell: TileData,layer: int, coord: Vector2i)->String:
	var pid = String.num(layer)+String.num(coord.x)+String.num(coord.y)
	var r= push_store_dict.get(pid,"")
	push_store_dict.erase(pid)
	return r

func handle_push_item_generate(player: Player,layer: int, veci: Vector2i, code: String,cell: TileData, level: TileAnimated, store: String):
	match code:
		"Takara":
			var ncode := new_code()
			level.index_title_anim(layer,veci,ncode,0)
		"Snario":
			var sid = store
			print("播放id的脚本文案 ",sid)
			player.trigger(sid)

func new_code()->String:
	var i = randi() % TAKARA_BOXS.size()
	return TAKARA_BOXS[i]


