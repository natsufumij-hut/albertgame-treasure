extends Node

signal update_hp(hp: int)
signal player_dead()
signal update_hpmax(max: int)
signal int_tile(player: Player)

var hp := 3
var hp_max := 3

func push_heart(h: int):
	hp+=h
	hp_max+=h
	update_hpmax.emit(hp_max)
	update_hp.emit(hp)

func heal(h: int):
	hp+=h
	if hp>hp_max:
		hp=hp_max
	update_hp.emit(hp)

func dec_heart(h: int):
	hp-=h
	if hp<0:
		hp=0
	update_hp.emit(hp)
	if hp==0:
		player_dead.emit()
