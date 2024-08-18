extends Building

@onready var detector: TowerEnemyDetectorComponent = $TowerEnemyDetectorComponent

var _shoot_cd: float = Constants.AT_SHOOT_CD
var _default_arrow_move_duration: float = Constants.AT_ARROW_MIN_MOVE_DURATION
var _arrow_damage: float = Constants.AT_ARROW_DAMAGE

var _shoot_cd_timer: float = 0
var _enemy_target: BaseEnemy
@export var _arrow_texture: Texture2D

func _process(delta: float) -> void:
	_shoot_cd_timer -= delta
	if _shoot_cd_timer <= 0.0:
		if _enemy_target == null:
			_enemy_target = detector.get_closest_enemy()
		if _enemy_target != null:
			shoot_arrow(_enemy_target)

func shoot_arrow(enemy: BaseEnemy) -> void:
	var dist: float = enemy.global_position.distance_to(global_position)
	var additional_dist_duration: float = remap(dist, 0.0, 100.0, 0.0, 0.5)
	var move_duration = _default_arrow_move_duration + additional_dist_duration
	var arrow = Arrow.new(_arrow_texture, global_position, enemy, _arrow_damage, move_duration)
	get_tree().get_root().add_child(arrow)
	_shoot_cd_timer = _shoot_cd

func _on_tower_enemy_detector_component_enemy_detected(enemy: BaseEnemy) -> void:
	if _enemy_target == null:
		_enemy_target = enemy
		shoot_arrow(enemy)

func _on_tower_enemy_detector_component_enemy_lost(enemy: BaseEnemy) -> void:
	if enemy == _enemy_target:
		_enemy_target = null
