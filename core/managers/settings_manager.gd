extends Node

#
# SETTINGSMANAGER
#

var _settings_config: ConfigFile
var settings_json: JSON = load("res://settings/settings_constants.json")

func _ready():
	_settings_config = ConfigFile.new()
	if !_try_load_settings():
		_create_config_file()

func _try_load_settings() -> bool:
	var err = _settings_config.load("user://settings.cfg")
	if err != OK:
		return false

	return true

func _create_config_file() -> void:
	for key in settings_json.data:
		var jsonObj:Dictionary = settings_json.data[key]
		_settings_config.set_value(jsonObj["section"], key, jsonObj["fallback"])

	_settings_config.save("user://settings.cfg")

func get_value(key:String):
	return _settings_config.get_value(settings_json.data[key].section, key)

func set_value(key:String, value:Variant):
	_settings_config.set_value(settings_json.data[key].section, key, value)

func save_settings() -> void:
	_settings_config.save("user://settings.cfg")

func _exit_tree():
	save_settings()
