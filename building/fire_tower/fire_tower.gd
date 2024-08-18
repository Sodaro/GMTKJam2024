extends Building

var enemy_target: BaseEnemy
@onready var detector: TowerEnemyDetectorComponent = $TowerEnemyDetectorComponent

var _burn_damage: float = Constants.FT_BURN_DAMAGE
var _burn_duration: float = Constants.FT_BURN_DURATION

func get_health_fraction() -> float:
	return $TowerHealthComponent.get_health_fraction()

func _process(delta: float) -> void:
	var max_count: int = 3
	var count = 0
	for enemy in detector.nearby_enemies:
		var burnable_comp: MonsterBurnableComponent = enemy.get_component(MonsterBurnableComponent)
		if burnable_comp != null:
			burnable_comp.burn(_burn_damage, _burn_duration)
			count += 1
			if count == max_count:
				break

func _on_tower_enemy_detector_component_enemy_detected(enemy: BaseEnemy) -> void:
	pass # Replace with function body.


func _on_tower_enemy_detector_component_enemy_lost(enemy: BaseEnemy) -> void:
	pass # Replace with function body.


func _on_tower_health_component_health_changed(new_amount: float) -> void:
	pass # Replace with function body.


func _on_tower_health_component_health_depleted() -> void:
	queue_free()
