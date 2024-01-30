extends NinePatchRect

func _ready() -> void:
	GameSignal.found_blade.connect(show_success)

func show_success():
	visible = true
	$GPUParticles2D.emitting=true
	$GPUParticles2D.emitting=true
	$GPUParticles2D.emitting=true
	$GPUParticles2D.emitting=true	

func close():
	visible = false

func exit():
	get_tree().quit()
