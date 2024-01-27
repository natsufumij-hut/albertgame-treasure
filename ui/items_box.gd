extends VBoxContainer

@onready var coinLabel := $Coin/Button/Label as Label
@onready var keyLabel := $Key/Button/Label as Label
@onready var mashLabel := $Mashroom/Button/Label as Label
@onready var bombLabel := $Bomb/Button/Label as Label
@onready var taiLabel := $Tai/Button/Label as Label
@onready var coin := $Coin/Button as TextureButton
@onready var key := $Key/Button as TextureButton
@onready var mash := $Mashroom/Button as TextureButton
@onready var bomb := $Bomb/Button as TextureButton
@onready var tai := $Tai/Button as TextureButton

func _ready() -> void:
	PlayerAsset.update_asset.connect(update_asset)
	load_asset()

func update_asset(code: String, num: int):
	var dict = prepare_set()
	if dict.has(code):
		var dest = dict[code]
		dest["button"].disabled = num==0
		dest["label"].text=String.num(num)

func load_asset():
	var asset = GameData.asset
	for n: String in asset:
		update_asset(n,asset[n])
	print('')
	PlayerAsset.syn_asset(asset)

func prepare_set()-> Dictionary:
	var dict := {}
	dict["Coin"]={ "label": coinLabel, "button": coin }
	dict["Key"]={ "label": keyLabel, "button": key }
	dict["Mashroom"]={ "label": mashLabel, "button": mash }
	dict["Bomb"]={ "label": bombLabel, "button": bomb }
	dict["Tai"]={ "label": taiLabel, "button": tai }
	return dict
