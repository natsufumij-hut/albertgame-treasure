extends NinePatchRect

func _ready() -> void:
	PlayerStats.player_dead.connect(dead)

func dead():
	visible = true
	$AudioStreamPlayer.playing=true

func exit():
	get_tree().quit()

func reload():
	GameSignal.level_reload.emit()
