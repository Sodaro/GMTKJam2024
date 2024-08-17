extends Node

class_name Main
func _ready():
	$GUI/MainMenu.play_button_pressed.connect(_on_play_button_pressed)
	_update_window_resolution()

func _update_window_resolution():
	var width:int = SettingsManager.get_value("window_width")
	var height:int = SettingsManager.get_value("window_height")
	var window:Window = get_window()
	var resolution = Vector2i(width, height)
	if !OS.has_feature("web"):
		if window.size != resolution:
			window.size = resolution
			window.move_to_center()
		window.mode = (SettingsManager.get_value("display_mode") as Window.Mode)
	else:
		window.mode = Window.MODE_MAXIMIZED


func _on_play_button_pressed():
	pass


func _on_world_world_started(time: Variant, gold: Variant, cool: Variant) -> void:
	print(time)
	print(gold)
	print(cool)
	pass # Replace with function body.
