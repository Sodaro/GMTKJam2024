extends Node2D

#@export var path_node: Path2D

signal health_changed(new_amount: float)
signal health_depleted()
var _health: float = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%WaveManager.on_enemy_castle_reached.connect(_enemy_reached)

func get_current_heath() -> float:
	return _health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enemy_reached(enemy: BaseEnemy) -> void:
	take_damage(1.0)

func take_damage(amount: float) -> void:
	_health -= amount
	health_changed.emit(_health)
	if _health <= 0:
		health_depleted.emit()
