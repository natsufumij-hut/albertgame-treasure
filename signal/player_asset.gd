extends Node

signal update_asset(code: String, v: int)
signal use_item(code: String, v: int)
signal trick_on(code: String,store: String,layer: int, veci: Vector2i)
signal trick_off()

var asset: Dictionary = {}
var trick: String = ""

func syn_asset(asset: Dictionary):
	self.asset=asset

## 添加资源
func put_asset(code: String, count: int):
	var temp = asset.get(code,0)
	temp+=count
	asset[code]=temp
	update_asset.emit(code,temp)
	GameData.set_asset(asset)

## 使用资源
func use_asset(code: String, count: int)->bool:
	var temp = asset.get(code,0)
	temp-=count
	if temp<0:
		print("无法使用该资源，资源数量不足")
		return false
	asset[code]=temp
	print("使用 ",code)
	update_asset.emit(code,temp)
	use_item.emit(code,count)
	GameData.set_asset(asset)
	return true

## 进入机关范围
func entry_trik(code: String, store: String,layer: int, veci: Vector2i):
	if trick!=code:
		trick=code
		print("entry trick ",code,store)
		trick_on.emit(code,store,layer,veci)

func clear_trick():
	trick=""
	trick_off.emit()
	
