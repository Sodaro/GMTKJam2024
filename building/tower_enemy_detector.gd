extends Area2D

class_name TowerEnemyDetectorComponent
signal enemy_detected(enemy: BaseEnemy)
signal enemy_lost(enemy: BaseEnemy)

var nearby_enemies: Array[BaseEnemy]
var cached_closest_enemy: BaseEnemy

@export var detection_range: int = 1

var get_closest_last_tick: int

func _ready() -> void:
	$CollisionShape2D.shape.size = Vector2(16 + detection_range * 16, 16 + detection_range * 16)

func get_closest_enemy() -> BaseEnemy:
	if Time.get_ticks_msec() == get_closest_last_tick:
		return cached_closest_enemy

	get_closest_last_tick = Time.get_ticks_msec()
	if nearby_enemies.size() == 0:
		cached_closest_enemy = null
	else:
		var closest_distance: float = Constants.MAX_FLOAT
		var closest_enemy = nearby_enemies[0]
		for enemy in nearby_enemies:
			var enemy_distance: float = enemy.global_position.distance_squared_to(global_position)
			if enemy_distance < closest_distance:
				closest_enemy = enemy
				closest_distance = enemy_distance
		cached_closest_enemy = closest_enemy
	return cached_closest_enemy

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.get_parent() is BaseEnemy:
		var enemy: BaseEnemy = area.get_parent()
		enemy_detected.emit(enemy)
		nearby_enemies.push_back(enemy)


func _on_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area == null:
		return
	if area.get_parent() is BaseEnemy:
		var enemy: BaseEnemy = area.get_parent()
		enemy_lost.emit(enemy)
		nearby_enemies.remove_at(nearby_enemies.find(enemy))
