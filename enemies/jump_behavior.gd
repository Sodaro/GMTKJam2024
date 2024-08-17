extends Node


var enemy:BaseEnemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#enemy.position.y = sin(Time.get_ticks_msec())
	pass
