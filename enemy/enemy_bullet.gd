class_name EnemyBullet
extends RigidBody2D

var att:int = 1
@export var dest_pos: Vector2
@export var speed := 100

@onready var anim: = $AnimationPlayer as AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vec = dest_pos - position
	vec = vec.normalized() * speed
	apply_impulse(vec,position)

func disapper():
	anim.play("disappear")

func _on_timer_timeout() -> void:
	disapper()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.go_attack(att)
		freeze=true
		disapper()

func _on_gpu_particles_2d_2_finished() -> void:
	queue_free()
