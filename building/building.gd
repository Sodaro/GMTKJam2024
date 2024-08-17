extends Node2D

class_name Building

var enemy_target: BaseEnemy

var nearby_enemies: Array[BaseEnemy]
var enemy_index: int = 0

func _ready() -> void:
	$EnemyDetector.enemy_detected.connect(_on_enemy_detected)

func _process(delta: float) -> void:
	if enemy_target != null:
		enemy_target.take_damage(3.5 * delta)
	elif nearby_enemies.size() > (enemy_index + 1):
		enemy_index += 1
		enemy_target = nearby_enemies[enemy_index]

func _on_enemy_detected(enemy: BaseEnemy):
	nearby_enemies.push_back(enemy)
	if enemy_target == null:
		enemy_target = enemy
		process_mode = PROCESS_MODE_ALWAYS
