extends Node2D

class_name TowerHealthComponent

var _max_health: float = 10
var _current_health: float = 10

signal health_changed(new_amount: float)
signal health_depleted

func get_current_health() -> float:
	return _current_health

func get_max_health() -> float:
	return _max_health

func get_health_fraction() -> float:
	return _current_health / _max_health

func take_damage(amount: float) -> void:
	_current_health -= amount
	health_changed.emit(_current_health)
	if (_current_health <= 0):
		_die()

func _die() -> void:
	health_depleted.emit()
