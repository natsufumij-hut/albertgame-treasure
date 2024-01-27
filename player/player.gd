class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var speed = SPEED
var jumpV = JUMP_VELOCITY

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var collide := PlayerCollide.new()
var needFrameTile := false
var secondJump := false
var sking := false
var current_frame_velocity := Vector2.ZERO
var damage_temp := 0

# 行动动画树
@onready var actionTree := $ActionTree as AnimationTree
@onready var stateTree := $StateTree as AnimationTree
@onready var itemTree := $ItemTree as AnimationTree
@onready var invTree := $InvTree as AnimationTree
@onready var animated := $AnimatedSprite2D as AnimatedSprite2D
@onready var tileDetect := $TileDetect as Marker2D
const REVERT_JUMP_LIST :Dictionary = { "Fall": true, "GroundNoSpeed": true, "GroundWithSpeed": true, "JumpStart": true, "SecondJumpStart": true  }
const REVERT_MOVE_LIST :Dictionary = { "MoveStart": true, "MoveEnd": true }
const REVERT_INV_LIST :Dictionary = {"InWater": true,"OutWater": true}

func _ready() -> void:
	PlayerAsset.use_item.connect(hand_use)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		sking = true
		velocity.y += gravity * delta
		if velocity.y > 0:
			param(actionTree,"Fall",REVERT_JUMP_LIST)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if not is_on_floor():
			if 	!secondJump:
				param(actionTree,"SecondJumpStart",REVERT_JUMP_LIST)
		else:
			param(actionTree,"JumpStart",REVERT_JUMP_LIST)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		param(actionTree,"MoveStart",REVERT_MOVE_LIST)
		animated.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		param(actionTree,"MoveEnd",REVERT_MOVE_LIST)
	current_frame_velocity=velocity
	var result := move_and_slide()
	if result:
		collide.handle_collide(self,get_last_slide_collision())
	else:
		collide.none_collide(self)
	PlayerStats.int_tile.emit(self)
	if is_on_floor():
		if sking:
			if velocity.x==0:
					param(actionTree,"GroundNoSpeed",REVERT_JUMP_LIST)
			else:
				param(actionTree,"GroundWithSpeed",REVERT_JUMP_LIST)
			sking=false


func param(animTree: AnimationTree, para: String, revert_dict: Dictionary):
	var p = "parameters/conditions/"+para
	animTree.set(p,true)
	var dict = revert_dict.duplicate()
	dict.erase(para)
	for n:String in dict:
		p = "parameters/conditions/"+n
		animTree.set(p,false)

## 跳跃
func jump():
	secondJump = false
	velocity.y = jumpV

func big_jump():
	secondJump = false
	velocity.y = jumpV * 3	

## 二段跳
func second_jump():
	secondJump = true
	velocity.y = jumpV

func attacked():
	PlayerStats.dec_heart(damage_temp)
	damage_temp=0

func hand_use(code: String, count: int):
	match code:
		"Tai":
			go_perfect_guard()
		"Mashroom":
			PlayerStats.heal(1)

func collect_hand(code: String):
	param(itemTree,"HandGot",{})

func go_perfect_guard():
	param(stateTree,"PerfectGuard",{})

func go_big_jump():
	param(actionTree,"BigJump",REVERT_JUMP_LIST)

func tiled():
	param(itemTree,"Tile",{})

func go_attack(att: int):
	damage_temp=att
	param(stateTree,"Attacked",{})

## 进入地形
func inTerrian(code: String):
	print("进入地形 ",code)
	param(invTree,"In"+code,REVERT_INV_LIST)

## 退出地形
func outTerrian(code: String):
	print("退出地形 ",code)
	param(invTree,"Out"+code,REVERT_INV_LIST)

func inWater():
	speed=SPEED/2
	jumpV=JUMP_VELOCITY*2
	print("speed ",speed)
	print("jumpv ",jumpV)

func outWater():
	speed=SPEED
	jumpV=JUMP_VELOCITY
	print("speed ",speed)
	print("jumpv ",jumpV)

func trigger(id: String):
	($SnarioPanel as SnarioPanel).trigger(id)
