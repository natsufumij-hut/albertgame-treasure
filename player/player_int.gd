class_name PlayerInt
## 处理没有物理形状的Tile

var int_dict: ={}

## 处理没有碰撞形状的Tile（水域、机关、门、火把）
func int_tile(player: Player, level: TileAnimated):
	var detected =player.tileDetect as Marker2D
	var gp = detected.global_position
	var loc = level.to_local(gp)
	var veci: Vector2i= level.local_to_map(loc)
	## 检测干涉地形、机关
	var terrian = int_layer(3,veci,level,player)
	var item = int_item_layer(5,veci,level,player)
	handle_int(terrian,player,item,veci)

func int_layer(layer: int, veci: Vector2i, level: TileAnimated, player: Player)-> String:
	var cell = level.get_cell_tile_data(layer,veci)
	if cell!=null:
		var code = cell.get_custom_data("TileCode")
		if code!=null and code!="":
			return code
	return ""

func int_item_layer(layer: int, veci: Vector2i, level: TileAnimated, player: Player) -> Array[String]:
	var cell = level.get_cell_tile_data(layer,veci)
	if cell==null:
		return ["",""]
	var store = cell.get_custom_data("Store")
	var code  = cell.get_custom_data("TileCode")
	store = store if store!=null else ""
	return [code,store]

func handle_int(terrian: String,player: Player, item: Array[String],veci: Vector2i):
	var ter = int_dict.get("terrian","")
	var ite = int_dict.get("item","")
	var itemCode = item[0]
	var itemStore = item[1]
	if ter!="" and terrian=="":
		print("退出干涉地形 ",ter)
		int_dict["terrian"]=""
		player.outTerrian(ter)
	elif ter=="" and terrian!="":
		print("进入干涉地形 ",terrian)
		int_dict["terrian"]=terrian
		player.inTerrian(terrian)
	if ite!="" and itemCode=="":
		print("退出交互道具 ",ite)
		int_dict["item"]=""
		PlayerAsset.trick_off.emit()
	elif ite=="" and itemCode!="":
		print("进入交互道具 ",itemCode," id为 ",itemStore)
		int_dict["item"]=itemCode+"/"+itemStore
		PlayerAsset.trick_on.emit(itemCode,itemStore,5,veci)
