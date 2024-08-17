extends Building

var enemy_target: BaseEnemy
@onready var detector: TowerEnemyDetectorComponent = $TowerEnemyDetectorComponent

func get_health_fraction() -> float:
	return $TowerHealthComponent.get_health_fraction()

func _process(delta: float) -> void:
	for enemy in detector.nearby_enemies:
		enemy.take_damage(delta)

func _on_tower_enemy_detector_component_enemy_detected(enemy: BaseEnemy) -> void:
	pass # Replace with function body.


func _on_tower_enemy_detector_component_enemy_lost(enemy: BaseEnemy) -> void:
	pass # Replace with function body.


func _on_tower_health_component_health_changed(new_amount: float) -> void:
	pass # Replace with function body.


func _on_tower_health_component_health_depleted() -> void:
	queue_free()
