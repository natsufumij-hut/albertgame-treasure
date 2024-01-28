extends RigidBody2D

@onready var bomb_area: = $Area2D as Area2D
@onready var bomb := $GPUParticles2D as GPUParticles2D

func _on_enemy_detect_body_entered(body: Node2D) -> void:
	bomb_area.monitoring=true
	bomb.emitting=true

func bomb_enemy(body: Node2D):
	if body.is_in_group("enemy"):
		body.got_attack(1)

func bomb_finish():
	queue_free()

func _on_timer_timeout() -> void:
	bomb_area.monitoring=true
	bomb.emitting=true
