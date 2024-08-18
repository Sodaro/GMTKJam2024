extends Node

class_name Main
func _ready():
	$World.get_node("Control/CanvasLayer").visible = false
	$World.process_mode = Node.PROCESS_MODE_DISABLED
	$GUI/MainMenu.play_button_pressed.connect(_on_play_button_pressed)
	_update_window_resolution()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_action"):
		get_tree().paused = !get_tree().paused

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
	$World.get_node("Control/CanvasLayer").visible = true
	$World.process_mode = Node.PROCESS_MODE_PAUSABLE
	$GUI.process_mode = Node.PROCESS_MODE_DISABLED
	$GUI.visible = false

func _on_world_world_started(time: Variant, gold: Variant, cool: Variant) -> void:
	print(time)
	print(gold)
	print(cool)
	pass # Replace with function body.
