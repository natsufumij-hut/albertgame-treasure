extends EnemyBase

@onready var actionTree := $actionTree as AnimationTree
@onready var stateTree := $stateTree as AnimationTree
@export var att := 1

const REVERT_ENEMY := {"EnemyEnter":true,"EnemyExit": true}

func _on_a_2_body_entered(body: Node2D) -> void:
	param(actionTree,"EnemyEnter",REVERT_ENEMY)

func _on_a_2_body_exited(body: Node2D) -> void:
	param(actionTree,"EnemyExit",REVERT_ENEMY)

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.go_attack(att)

func got_attacked():
	param(stateTree,"Attacked",{})

func dead():
	param(stateTree,"Dead",{})
