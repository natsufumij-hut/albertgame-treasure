extends EnemyBase

const MOVE_REVERT := {"MoveFrom":true,"MoveRight": true,"MoveEnd": true}
const ENEMY_REVERT := {"EnemyEnter":true,"EnemyExit":true}

@onready var actionTree := $ActionTree as AnimationTree
@onready var stateTree := $StateTree as AnimationTree
@onready var animated := $AnimatedSprite2D as AnimatedSprite2D

var enemy_target :Node2D

@export var p1:Marker2D
@export var p2:Marker2D
@export var revert_node: Array[Node2D]

var target_pos: =Vector2.ZERO
var is_move:  = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
	if is_move:
		var dis = position.x - target_pos.x
		if abs(dis)<30:
			paramState(actionTree,"Patrol","MoveEnd",{})
			is_move=false
			velocity.x=0

func got_attacked():
	no_speed()
	param(stateTree,"Attacked",{})

func dead():
	param(stateTree,"Dead",{})

func move_to_from():
	target_pos=p1.global_position
	orient_to(target_pos)
	velocity_to(target_pos)
	paramState(actionTree,"Patrol","MoveFrom",MOVE_REVERT)
	param(actionTree,"",ENEMY_REVERT)
	animated.play("move")
	print("move from")
	is_move=true
	print("velocity ",velocity)

func velocity_to(vec: Vector2):
	var del = (vec-position).normalized().x
	velocity.x = del * speed		

func move_to_right():
	target_pos=p2.global_position
	orient_to(target_pos)
	velocity_to(target_pos)
	paramState(actionTree,"Patrol","MoveRight",MOVE_REVERT)
	animated.play("move")
	print("move right")
	is_move=true

func orient_to(vec: Vector2):
	var del = (vec-position).normalized().x
	animated.flip_h=del>0
	for n in revert_node:
		n.scale.x = 1 if del<0 else -1

func orient_enemy():
	target_pos=enemy_target.global_position
	orient_to(target_pos)
	velocity.x=0

func crash():
	speed=SPEED*2
	velocity_to(target_pos)

func normal_stat():
	speed=SPEED

func no_speed():
	velocity.x=0

func enemy_enter(body: Node2D):
	enemy_target=body
	param(actionTree,"EnemyEnter",ENEMY_REVERT)
	print("敌人进入了！！")

func enemy_exit(body: Node2D):
	if enemy_target==body:	
		print("敌人逃离了！！")
		param(actionTree,"EnemyExit",ENEMY_REVERT)
	enemy_target=null

func attacked_enemy(body: Node2D):
	if body.is_in_group("player"):
		body.go_attack(1)
