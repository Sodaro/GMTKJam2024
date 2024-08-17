extends Node2D

#@export var path_node: Path2D

signal health_changed(old_amount: float, new_amount: float)
var _health: float = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%WaveManager.on_enemy_castle_reached.connect(_enemy_reached)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _enemy_reached(enemy: BaseEnemy) -> void:
	take_damage(1.0)

func take_damage(amount: float) -> void:
	var old_amount: float = _health
	_health -= amount
	health_changed.emit(old_amount, _health)
