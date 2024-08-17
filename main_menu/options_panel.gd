extends Panel

signal back_button_pressed()
var _window_resolution:Vector2i
var _display_mode:int

@export var window_constants_resource:WindowConstants

func _ready():
	if !OS.has_feature("web"):
		_initialize_window_options()
	else:
		_remove_window_options()

	%MasterVolumeSlider.value = AudioManager.get_master_volume()
	%MusicVolumeSlider.value = AudioManager.get_music_volume()
	%SoundVolumeSlider.value = AudioManager.get_sfx_volume()

func _initialize_window_options():
	_populate_display_mode_options()
	_populate_resolution_options()
	var width:int = SettingsManager.get_value("window_width")
	var height:int = SettingsManager.get_value("window_height")
	_display_mode = SettingsManager.get_value("display_mode")
	_window_resolution = Vector2i(width, height)
	var display_mode_option_index:int
	for value in window_constants_resource.display_mode_options.values():
		if value == _display_mode:
			break
		display_mode_option_index += 1
	var resolution_option_index:int
	for value in window_constants_resource.resolution_options.values():
		if value == _window_resolution:
			break
		resolution_option_index += 1
	%DisplayModeOptionButton.select(display_mode_option_index)
	%ResolutionOptionButton.select(resolution_option_index)
	_check_disable_resolution_options()


func _remove_window_options():
	$VBoxContainer/VBoxContainer/VisualsBoxContainer/DisplayModeContainer/DisplayModeLabel.visible = false
	$VBoxContainer/VBoxContainer/VisualsBoxContainer/ResolutionContainer/ResolutionLabel.visible = false
	%DisplayModeOptionButton.visible = false
	%ResolutionOptionButton.visible = false
	%DisplayModeOptionButton.disabled = true
	%ResolutionOptionButton.disabled = true

func _populate_display_mode_options():
	%DisplayModeOptionButton.clear()
	for key in window_constants_resource.display_mode_options.keys():
		%DisplayModeOptionButton.add_item(key)

func _populate_resolution_options():
	%ResolutionOptionButton.clear()
	for key in window_constants_resource.resolution_options.keys():
		%ResolutionOptionButton.add_item(key)

func _check_disable_resolution_options():
	if _display_mode == Window.MODE_EXCLUSIVE_FULLSCREEN || _display_mode == Window.MODE_FULLSCREEN:
		%ResolutionOptionButton.disabled = true
	else:
		%ResolutionOptionButton.disabled = false

func _update_display_mode(mode:Window.Mode):
	get_window().mode = mode
	_display_mode = mode
	SettingsManager.set_value("display_mode", _display_mode)
	_check_disable_resolution_options()

func _on_display_mode_option_button_item_selected(index:int):
	var key:String = %DisplayModeOptionButton.get_item_text(index)
	_update_display_mode(window_constants_resource.display_mode_options[key])

func _on_resolution_option_button_item_selected(index:int):
	var key:String = %ResolutionOptionButton.get_item_text(index)
	_window_resolution = window_constants_resource.resolution_options[key]
	var window:Window = get_window()
	window.size = _window_resolution
	window.move_to_center()
	SettingsManager.set_value("window_width", _window_resolution.x)
	SettingsManager.set_value("window_height", _window_resolution.y)

func _on_master_slider_value_changed(value:float):
	AudioManager.set_master_volume(value)

func _on_music_slider_value_changed(value:float):
	AudioManager.set_music_volume(value)

func _on_sound_slider_value_changed(value:float):
	AudioManager.set_sfx_volume(value)

func _on_back_button_pressed():
	back_button_pressed.emit()
	SettingsManager.save_settings()
