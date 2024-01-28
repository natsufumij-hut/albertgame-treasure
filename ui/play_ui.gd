extends Control

var useCode: String = ""
var store: String = ""
var used: bool = false
var layer: int=0
var veci: Vector2i=Vector2i.ZERO

func _ready() -> void:
	if OS.has_feature("mobile"):
		$MobilePlay.visible = true
		$PCPlay.visible = false
	PlayerAsset.trick_on.connect(trigger_use)
	PlayerAsset.trick_off.connect(clear_use)
	GameSignal.log.connect(log_info)
	
func _on_leff_button_down() -> void:
	Input.action_press("ui_left")

func _on_leff_button_up() -> void:
	Input.action_release("ui_left")

func _on_right_button_down() -> void:
	Input.action_press("ui_right")

func _on_right_button_up() -> void:
	Input.action_release("ui_right")

func _on_up_button_down() -> void:
	Input.action_press("ui_accept")

func _on_up_button_up() -> void:
	Input.action_release("ui_accept")

func log_info(str: String):
	($Log as Label).text=str

func trigger_use(code: String,stroe: String,layer: int, veci: Vector2i):
	useCode=code
	store=stroe
	$Use.visible=true
	used=false
	self.layer=layer
	self.veci=veci

func clear_use():
	useCode=""
	used=false
	$Use.visible=false

func _on_use_pressed() -> void:
	if !used:
		print("use ",useCode)
		print("store ",store)
		print("layer ",layer)
		print("vec ",veci)
		used=true
		match useCode:
			"Door":
				use_door(store)
			"Switch":
				use_switch(store)

func use_switch(store: String):
	var r = PlayerAsset.use_asset("Coin",1)
	if !r:
		return	
	print("use switch ",store)
	LevelSignal.clear_tile.emit(layer,veci)
	if store.contains(","):
		var sp = store.split(",")
		for s: String in sp:
			LevelSignal.use_trick.emit(s)
	else:
		LevelSignal.use_trick.emit(store)

func use_door(store: String):
	var r = PlayerAsset.use_asset("Key",1)
	if !r:
		return
	var level = store.to_int()
	GameSignal.new_level.emit(level)
