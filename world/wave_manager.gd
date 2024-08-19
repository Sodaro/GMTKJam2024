extends Node

class_name WaveManager

signal on_enemy_castle_reached(enemy : BaseEnemy)
signal on_level_changed(new_level : int)
signal on_enemy_spawned(enemy: BaseEnemy)
signal on_level_finished(max_level : int)
signal on_max_level_reached()

var _current_wave_number: int = 0
var _enemies_to_spawn: int = 0
var _special_enemies_to_spawn: int = 0
var _base_enemies_to_spawn: int = 0
var _current_spawn_interval: float = 0.0
var _spawn_timer: float = 0.0
var _max_level_reached: bool = false
var _level_finished: bool = false

var enemy_scene: Resource = load("res://enemies/blob_enemy.tscn")

var added_monster_resources: Dictionary
var wave_special_monsters: Dictionary

var current_monster_resource: MonsterResource

@export var default_monster: MonsterResource
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

class WaveData:
	var current_wave_number: int = 0
	var enemies_to_spawn: int = 0
	var special_enemies_to_spawn: int = 0
	var base_enemies_to_spawn: int = 0
	var current_spawn_interval: float = 0.0
	var wave_special_monsters: Dictionary

var next_wave_data: WaveData
var current_wave_data: WaveData

func get_next_wave_data() -> WaveData:
	return next_wave_data

func restart() -> void:
	_current_wave_number = 0
	_enemies_to_spawn = 0
	_current_spawn_interval = 0
	_spawn_timer = 0
	_special_enemies_to_spawn = 0
	_base_enemies_to_spawn = 0

	#wave_special_monsters.clear()
	added_monster_resources.clear()
	current_monster_resource = default_monster
	_generate_next_wave()

func _generate_next_wave() -> void:
	if _max_level_reached:
		return
	next_wave_data = WaveData.new()
	var wave_nr: int = _current_wave_number + 1
	next_wave_data.current_wave_number = wave_nr
	next_wave_data.special_enemies_to_spawn = _get_number_of_special_enemies(wave_nr)
	next_wave_data.base_enemies_to_spawn = _get_number_of_base_enemies(wave_nr)
	next_wave_data.enemies_to_spawn += next_wave_data.base_enemies_to_spawn + next_wave_data.special_enemies_to_spawn
	next_wave_data.current_spawn_interval = _get_spawn_interval(next_wave_data.enemies_to_spawn, wave_nr)

func next_wave() -> void:
	if _max_level_reached:
		return

	if _current_wave_number >= max_level && !_max_level_reached:
		_max_level_reached = true
		on_max_level_reached.emit()
		return

	_spawn_timer = 0
	_current_wave_number = next_wave_data.current_wave_number
	_special_enemies_to_spawn = next_wave_data.special_enemies_to_spawn
	_base_enemies_to_spawn = next_wave_data.base_enemies_to_spawn
	_enemies_to_spawn = next_wave_data.enemies_to_spawn
	_current_spawn_interval = next_wave_data.current_spawn_interval
	wave_special_monsters = next_wave_data.wave_special_monsters
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

func _get_number_of_special_enemies(wave_number: int) -> int:
	var count: int = 0
	for resource in added_monster_resources:
		if wave_number >= added_monster_resources[resource].first_wave:
			count += added_monster_resources[resource].count
			next_wave_data.wave_special_monsters[resource] = count
	return count

func _spawn_enemy():
	if enemy_scene:
		var enemy_instance : BaseEnemy = enemy_scene.instantiate()

		enemy_instance.initialize(current_monster_resource)
		enemy_instance.reached_castle.connect(_enemy_reached_castle)
		enemy_path.add_child(enemy_instance)
		on_enemy_spawned.emit(enemy_instance)
	else:
		print("Enemy scene is not assigned!")

func _try_spawn_enemies(delta: float) -> void:
	if _level_finished:
		return

	if _has_finished() && !_level_finished:
		_level_finished = true
		on_level_finished.emit(max_level)
		return

	if _enemies_to_spawn > 0:
		_spawn_timer += delta
		if _spawn_timer >= _current_spawn_interval:
			if _enemies_to_spawn <= _special_enemies_to_spawn:
				if wave_special_monsters.size() > 0:
					for resource in wave_special_monsters:
						if wave_special_monsters[resource] > 0:
							current_monster_resource = resource
							wave_special_monsters[resource] -= 1
							break
			else:
				current_monster_resource = default_monster

			_spawn_enemy()
			_enemies_to_spawn -= 1
			_spawn_timer = 0.0

func _enemy_reached_castle(enemy : BaseEnemy) -> void:
	on_enemy_castle_reached.emit(enemy)

func _has_finished() -> bool:
	return _enemies_to_spawn <= 0 && _current_wave_number >= max_level

func _ready() -> void:
	restart()
	%BuildingPlacementManager.building_purchased.connect(_on_building_purchased)
	%BuildingPlacementManager.building_sold.connect(_on_building_sold)

func _on_building_purchased(building_resource: BuildingResource):
	var monster_resource: MonsterResource = building_resource.added_enemy_resource
	var monster_count: int = building_resource.added_enemy_count
	if !added_monster_resources.has(monster_resource):
		var data: Dictionary
		data.count = 0
		data.first_wave = _current_wave_number + 2
		added_monster_resources[monster_resource] = data
	added_monster_resources[building_resource.added_enemy_resource].count += monster_count

func _on_building_sold(building_resource: BuildingResource):
	var monster_resource: MonsterResource = building_resource.added_enemy_resource
	var monster_count: int = building_resource.added_enemy_count
	if !added_monster_resources.has(monster_resource):
		return
	added_monster_resources[building_resource.added_enemy_resource].count -= maxf(0, monster_count)

func _process(delta: float) -> void:
	_try_spawn_enemies(delta)

func _on_next_wave_button_button_up() -> void:
	next_wave()
	_generate_next_wave()
