extends Building

var enemy_target: BaseEnemy
@onready var detector: TowerEnemyDetectorComponent = $TowerEnemyDetectorComponent

var _shoot_cd = 0.75
var _shoot_cd_timer = 0
var _default_arrow_move_duration = 0.5
@export var _arrow_texture: Texture2D

func _process(delta: float) -> void:
	_shoot_cd_timer -= delta
	if _shoot_cd_timer <= 0.0 && detector.get_closest_enemy() != null:
		shoot_arrow(detector.get_closest_enemy())

func shoot_arrow(enemy: BaseEnemy) -> void:
	var dist: float = enemy.global_position.distance_to(global_position)
	var additional_dist_duration: float = remap(dist, 0.0, 100.0, 0.0, 0.5)
	var move_duration = _default_arrow_move_duration + additional_dist_duration
	var arrow = Arrow.new(_arrow_texture, global_position, enemy, move_duration)
	get_tree().get_root().add_child(arrow)
	_shoot_cd_timer = _shoot_cd

func _on_tower_enemy_detector_component_enemy_detected(enemy: BaseEnemy) -> void:
	if enemy_target == null:
		enemy_target = enemy
		shoot_arrow(enemy)

func _on_tower_enemy_detector_component_enemy_lost(enemy: BaseEnemy) -> void:
	if enemy == enemy_target:
		enemy_target = detector.get_closest_enemy()
