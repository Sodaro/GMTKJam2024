extends Node2D

var _wave_spawn_count: int = 0
var _wave_kill_count: int = 0
var _level_finished: bool = false
var _win_lose_display: Control
var _current_wave_data: WaveManager.WaveData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.WORLD = self
	$WaveManager.on_enemy_spawned.connect(_on_enemy_spawned)
	$WaveManager.on_level_finished.connect(_on_level_finished)
	%WaveManager.on_level_changed.connect(_on_level_changed)
	%WaveManager.on_enemy_castle_reached.connect(_on_enemy_reached_castle)
	$CastleCore.health_depleted.connect(_on_castle_health_depleted)
	_win_lose_display = get_tree().get_root().get_node("Main/GUI/WinLoseDisplay")
	_level_finished = false
	_win_lose_display.hide_end_menu()
#func _on_castle_core_health_changed(new_amount: float) -> void:
	#%CastleCoreHealthLabel.text = str(new_amount)

func _on_enemy_reached_castle(enemy : BaseEnemy):
	_wave_kill_count += 1
	_check_wave_killed()

func _check_wave_killed():
	if _level_finished:
		if _wave_kill_count == _wave_spawn_count:
			$Control/CanvasLayer.visible = false
			_win_lose_display.show_end_menu(true, _current_wave_data)
	else:
		if _wave_kill_count == _wave_spawn_count:
			%NextWaveButton.disabled = false

func _on_blob_enemy_reached_castle(damage: float) -> void:
	%CastleCore.take_damage(damage)

func _on_enemy_spawned(enemy: BaseEnemy):
	#_spawn_count += 1
	enemy.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(resource: MonsterResource):
	_wave_kill_count += 1
	_check_wave_killed()
	#_kill_count += 1

func _on_level_changed(wave_data: WaveManager.WaveData):
	_wave_spawn_count = wave_data.enemies_to_spawn
	_wave_kill_count = 0
	#print(str(_wave_spawn_count))
	%NextWaveButton.disabled = true
	_current_wave_data = wave_data

func _on_level_finished(max_level: int):
	_level_finished = true
	#%NextWaveButton.visible = false
	#%NextWaveButton.disabled = true

func _on_castle_health_depleted():
	$Control/CanvasLayer.visible = false
	_win_lose_display.show_end_menu(false, _current_wave_data)
