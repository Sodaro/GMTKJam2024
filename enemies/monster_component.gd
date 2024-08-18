extends Node2D
class_name MonsterComponent

var monster: BaseEnemy

func _ready():
	monster = get_parent()
	monster.register_component(self)
