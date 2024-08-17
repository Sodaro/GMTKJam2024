extends Area2D

signal enemy_detected(enemy: BaseEnemy)

@export var detection_radius: float = 32

func _ready() -> void:
	$CollisionShape2D.shape.radius = detection_radius

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.get_parent() is BaseEnemy:
		var enemy: BaseEnemy = area.get_parent()
		enemy_detected.emit(enemy)
