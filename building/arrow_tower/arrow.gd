extends Sprite2D

class_name Arrow

var _enemy_target: BaseEnemy
var _start_pos: Vector2
var _move_duration: float
var _enemy_pos: Vector2
var _move_timer: float

func _init(arrow_texture: Texture2D, start_pos: Vector2, target: BaseEnemy, move_duration: float) -> void:
	global_position = start_pos
	_start_pos = start_pos
	_enemy_target = target
	_move_duration = move_duration
	_enemy_pos = _enemy_target.global_position
	texture = arrow_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_move_timer += delta
	if _enemy_target != null:
		_enemy_pos = _enemy_target.global_position

	global_position = _start_pos.lerp(_enemy_pos, minf(_move_timer / _move_duration, 1.0))
	look_at(_enemy_pos)
	if _move_timer >= _move_duration:
		if _enemy_target != null:
			_enemy_target.take_damage(1.0)
		queue_free()
