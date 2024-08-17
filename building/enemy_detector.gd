extends Area2D

signal enemy_detected(enemy: BaseEnemy)

@export var detection_radius: float = 32

func _ready() -> void:
	$CollisionShape2D.shape.radius = detection_radius

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is BaseEnemy:
		var enemy: BaseEnemy = area.get_parent()
		enemy_detected.emit(enemy)
