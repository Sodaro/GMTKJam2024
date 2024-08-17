extends Building

var enemy_target: BaseEnemy
@onready var detector: TowerEnemyDetectorComponent = $TowerEnemyDetectorComponent

var arrow_move_duration = 0.5
var arrow_move_timer = 0
var enemy_position: Vector2

func _process(delta: float) -> void:
	if enemy_target != null:
		enemy_position = enemy_target.global_position

	arrow_move_timer += delta
	var pos = lerp(global_position, enemy_position, arrow_move_timer / arrow_move_duration)
	pos += $Arrow.transform.y * sin(TAU * (1 / arrow_move_duration) * arrow_move_timer) * 64
	$Arrow.global_position = pos
	$Arrow.look_at(enemy_position)
	if arrow_move_timer >= arrow_move_duration:
		if enemy_target != null:
			enemy_target.take_damage(0.5)
			shoot_arrow()
		else:
			stop_shooting()


func shoot_arrow() -> void:
	$Arrow.visible = true
	$Arrow.global_position = Vector2.ZERO
	arrow_move_timer = 0

func stop_shooting() -> void:
	$Arrow.visible = false
	$Arrow.global_position = Vector2.ZERO

func _on_tower_enemy_detector_component_enemy_detected(enemy: BaseEnemy) -> void:
	if enemy_target == null:
		enemy_target = enemy
		shoot_arrow()


func _on_tower_enemy_detector_component_enemy_lost(enemy: BaseEnemy) -> void:
	if enemy == enemy_target:
		enemy_target = detector.get_closest_enemy()
