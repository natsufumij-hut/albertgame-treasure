class_name EnemyBase
extends CharacterBody2D

enum EnemyType {
	## 陆生(冲撞)
	LAND, 
	## 水生(冲撞)
	WATER, 
	## 不动类(不攻击)
	NO_MOVE,
	## 飞行类(子弹) 
	FLY, 
	## 特殊类(自定义)
	SPECIAL, 
}

var enemy_type: EnemyType 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 200.0
var speed = SPEED

@onready var animTree: = $AnimationTree as AnimationTree

## 血量,默认1
@export var hp: int = 1
var alive: bool = true

## 受到伤害
func got_attack(at: int):
	if !alive:
		return
	var h = hp-at
	if h<0:
		h=0
	hp=h 
	if hp==0:
		alive=false
		dead()

func dead():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and enemy_type==EnemyType.LAND:
		velocity.y += gravity * delta
	move_and_slide()
	enemy_update(delta)

func enemy_update(delta: float):
	pass

func param(animTree: AnimationTree, para: String, revert_dict: Dictionary):
	var p = "parameters/conditions/"+para
	animTree.set(p,true)
	var dict = revert_dict.duplicate()
	dict.erase(para)
	for n:String in dict:
		p = "parameters/conditions/"+n
		animTree.set(p,false)

func paramState(animTree: AnimationTree,state: String, para: String, revert_dict: Dictionary):
	var p = "parameters/"+state+"/conditions/"+para
	animTree.set(p,true)
	var dict = revert_dict.duplicate()
	dict.erase(para)
	for n:String in dict:
		p = "parameters/"+state+"/conditions/"+n
		animTree.set(p,false)

