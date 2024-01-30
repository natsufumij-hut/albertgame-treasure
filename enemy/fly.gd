extends EnemyBase

@export var p1: Marker2D
@export var p2: Marker2D
@export var revert_node: Array[Node2D]

var pos: Vector2
var target_enemy: Node2D

@onready var actionTree := $actionTree as AnimationTree
@onready var stateTree := $stateTree as AnimationTree
@onready var animated  := $AnimatedSprite2D as AnimatedSprite2D
@onready var marker :=$Shoot/Marker2D as Marker2D

const MOVE_REVERT = {"MoveEnd":true,"MoveLeft":true,"MoveRight":true}

var bullet := preload("res://enemy/enemy_bullet.tscn") as PackedScene

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
		
	move_and_slide()

func move_to_from():
	set_pos_from()
	orient_to_pos()
	speed_to_pos()

func move_to_right():
	set_pos_right()
	orient_to_pos()
	speed_to_pos()

func check_move():
	var del = position.x-pos.x
	print("check ",del)
	if abs(del)<30:
		paramState(actionTree,"Patrol","MoveEnd",{})

func set_pos_from():
	pos=p1.global_position

func set_pos_right():
	pos=p2.global_position

func orient_to_pos():
	var del = pos.x-position.x
	if del!=0:
		var flip = del>0
		for n in revert_node:
			n.scale.x = -1 if flip else 1
		animated.flip_h=flip
			

func orient_to_enemy():
	if target_enemy==null:
		param(actionTree,"EnemyExit",{})
		return
	pos=target_enemy.position
	orient_to_pos()
	no_speed()

func speed_to_pos():
	var dell = pos.x-position.x
	if dell==0:
		return
	var sp = 1 if dell>0 else -1
	velocity.x = sp * speed

func no_speed():
	velocity.x=0

func boot_bullet():
	print("发射子弹")
	var bu = bullet.instantiate() as EnemyBullet
	bu.position = marker.global_position
	bu.dest_pos = target_enemy.position
	LevelSignal.put_bullet.emit(bu)

func got_attacked():
	param(stateTree,"Attacked",{})

func dead():
	param(actionTree,"Dead",{})
	param(stateTree,"Dead",{})

func enemy_enter(body: Node2D):
	if body.is_in_group("player"):
		target_enemy=body
		param(actionTree,"EnemyEnter",{})
	
func enemy_exit(body: Node2D):
	if body.is_in_group("player"):
		target_enemy=null
		param(actionTree,"EnemyExit",{})
