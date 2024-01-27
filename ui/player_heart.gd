extends HBoxContainer

const HP_CONST = 3
const HP_MAX = 9

@export var empty: Texture2D
@export var full: Texture2D

@onready var lifeTemp: Control = $LifeTemp

@export var HPMax: int = HP_CONST
@export var HP: int = HP_CONST

func _ready() -> void:
	PlayerStats.update_hp.connect(update_hp_label)
	PlayerStats.update_hpmax.connect(update_hp_max)
	load_hp()

func load_hp():
	var hm = GameData.asset.get("hp_max",3)
	update_hp_max(hm,false)
	var h = GameData.asset.get("hp",3)
	update_hp_label(h,false)

func update_hp_label(hp: int,save=true):
	HP=hp
	for i in range(1,HPMax+1):
		var nameL = "Life{n}".format({"n":i})
		var no = get_node(nameL)
		if i>=1 and i<=HP:
			no.texture = full
		if i>HP:
			no.texture = empty
	if save:
		GameData.asset["hp"]=hp

func update_hp_max(hm: int,save=true):
	HPMax=hm
	for i in range(1,HP_MAX+1):
		var nameL = "Life{n}".format({"n":i})
		var no = get_node(nameL)
		if i <= HPMax:
			no.texture = full
			no.visible = true
		else:
			no.texture = full
			no.visible = false
	if save:
		GameData.asset["hp_max"]=hm
		
