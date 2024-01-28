extends NinePatchRect

func _ready() -> void:
	PlayerAsset.need_asset.connect(need)

func need(code: String, count: int):
	var items = prepare()
	disable_all(items)
	enable_one(items,code)
	var nums = prepareNum()
	disable_all(nums)
	enable_one(nums,String.num(count))
	visible = true
	$AudioStreamPlayer.playing=true

func close():
	visible = false

func disable_all(items: Dictionary):
	for n in items:
		var item = items[n] as Control
		item.visible = false
	
func enable_one(items: Dictionary, code: String):
	var dest = items.get(code)
	if dest!=null:
		dest.visible = true	

func prepare()->Dictionary:
	var dic = {
		"Key": $iten/key,
		"Coin": $iten/coin
	}
	return dic

func prepareNum()->Dictionary:
	return {
		"1": $num/n1,
		"2": $num/n2,
		"3": $num/n3,
		"4": $num/n4,
		"5": $num/n5,
		"6": $num/n6,
		"7": $num/n7,
		"8": $num/n8,
		"9": $num/n9,
	}
