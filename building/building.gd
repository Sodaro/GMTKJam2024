class_name Building extends Node2D
var gold_cost: int = 0
var refund_value: int = 0

func get_health_fraction() -> float:
	return 1.0

func get_sell_value() -> int:
	# lower health -> higher alpha -> less money received for selling
	var damage_alpha: float = lerpf(0.0, 1.0, 1 - get_health_fraction())
	var deduction: float = damage_alpha * refund_value
	return refund_value
