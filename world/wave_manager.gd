extends Node

class_name WaveManager

signal on_enemy_castle_reached(enemy : BaseEnemy)
signal on_level_changed(new_level : int)
signal on_enemy_spawned(enemy: BaseEnemy)
signal on_level_finished()
signal on_max_level_reached()

var _current_wave_number: int = 0
var _enemies_to_spawn: int = 0
var _current_spawn_interval: float = 0.0
var _spawn_timer: float = 0.0
var _max_level_reached: bool = false
var _level_finished: bool = false

var enemy_scene: Resource = load("res://enemies/blob_enemy.tscn")
@export var monster_resources: Array[MonsterResource]
@export var enemy_path: Path2D
@export var max_level: int = 12

# Enemy growth-related
@export var start_enemies: int = 5
@export var growth_rate: float = 0.2
@export var difficulty_modifier: float = 1.0
@export var randomness_factor: float = 0.1

# Timing-related
@export var max_spawn_time: float = 30.0
@export var base_spawn_time: float = 10.0
@export var spawn_time_scaling_factor: float = 0.1

func restart() -> void:
	_current_wave_number = 0
	_enemies_to_spawn = 0
	_current_spawn_interval = 0
	_spawn_timer = 0

func next_wave() -> void:
	if _current_wave_number >= max_level && !_max_level_reached:
		_max_level_reached = true
		on_max_level_reached.emit()
		return

	_current_wave_number += 1
	_spawn_timer = 0
	_enemies_to_spawn += _get_number_of_base_enemies(_current_wave_number)
	_current_spawn_interval = _get_spawn_interval(_enemies_to_spawn, _current_wave_number)
	on_level_changed.emit(_current_wave_number)

func get_current_wave_number() -> int:
	return _current_wave_number

func _get_spawn_interval(enemies_count: int, wave_number: int) -> float:
	var wave_spawn_time: float = base_spawn_time + (wave_number * spawn_time_scaling_factor)
	wave_spawn_time = min(wave_spawn_time, max_spawn_time)
	return wave_spawn_time / enemies_count

func _get_number_of_base_enemies(wave_number: int) -> int:
	var enemies = start_enemies * (1 + growth_rate * log(wave_number + 1)) * difficulty_modifier
	enemies *= 1 + randf_range(-randomness_factor, randomness_factor)
	return int(round(enemies))

func _spawn_enemy():
	if enemy_scene:
		var enemy_instance : BaseEnemy = enemy_scene.instantiate()
		enemy_instance.initialize(monster_resources.pick_random())
		enemy_instance.reached_castle.connect(_enemy_reached_castle)
		enemy_path.add_child(enemy_instance)
		on_enemy_spawned.emit(enemy_instance)
	else:
		print("Enemy scene is not assigned!")

func _try_spawn_enemies(delta: float) -> void:
	if _has_finished() && !_level_finished:
		_level_finished = true
		on_level_finished.emit()
		return

	if _enemies_to_spawn > 0:
		_spawn_timer += delta

		if _spawn_timer >= _current_spawn_interval:
			_spawn_enemy()
			_spawn_timer = 0.0
			_enemies_to_spawn -= 1

func _enemy_reached_castle(enemy : BaseEnemy) -> void:
	on_enemy_castle_reached.emit(enemy)

func _has_finished() -> bool:
	return _enemies_to_spawn <= 0 && _current_wave_number >= max_level

func _ready() -> void:
	restart()

func _process(delta: float) -> void:
	_try_spawn_enemies(delta)

func _on_next_wave_button_button_up() -> void:
	next_wave()
