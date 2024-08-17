extends PathFollow2D

class_name BaseEnemy

var health: float = 10.0
signal reached_castle(damage: float)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * 50
	if progress_ratio >= 1.0:
		reached_castle.emit(1.0)
		queue_free()

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		queue_free()
