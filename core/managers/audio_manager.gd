extends Node

#
# AudioManager
#

var _master_volume:float
var _music_volume:float
var _sfx_volume:float

func _ready() -> void:
	_master_volume = SettingsManager.get_value("master_volume")
	_music_volume = SettingsManager.get_value("music_volume")
	_sfx_volume = SettingsManager.get_value("sfx_volume")

func _update_audio_bus(normalized_value:float, bus_name:String) -> void:
	var bus_idx:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_idx, _convert_to_db(normalized_value))

func get_master_volume() -> float:
	return _master_volume

func get_music_volume() -> float:
	return _music_volume

func get_sfx_volume() -> float:
	return _sfx_volume

func set_master_volume(normalized_value:float) -> void:
	_update_audio_bus(normalized_value, "Master")
	_master_volume = normalized_value


func set_music_volume(normalized_value:float) -> void:
	_update_audio_bus(normalized_value, "Music")
	_music_volume = normalized_value

func set_sfx_volume(normalized_value:float) -> void:
	_update_audio_bus(normalized_value, "SFX")
	_sfx_volume = normalized_value

func _convert_to_db(normalized_value:float) -> float:
	var db:float
	if normalized_value != 0.0:
		db = 20.0 * log(normalized_value) / log(10)
	else:
		db = -80.0
	return db

func convert_to_linear(decibel_value:float) -> float:
	return 1 * pow(10, decibel_value / 10)

func _exit_tree() -> void:
	SettingsManager.set_value("master_volume", _master_volume)
	SettingsManager.set_value("music_volume", _music_volume)
	SettingsManager.set_value("sfx_volume", _sfx_volume)
