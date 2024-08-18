extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.WORLD = self
	#$CastleCore.health_changed.
	pass # Replace with function body.

func _on_castle_core_health_changed(old_amount: float, new_amount: float) -> void:
	%CastleCoreHealthLabel.text = str(new_amount)


func _on_blob_enemy_reached_castle(damage: float) -> void:
	%CastleCore.take_damage(damage)
