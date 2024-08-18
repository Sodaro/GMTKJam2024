extends Node
class_name Main

enum GameMode {NONE, MENU, GAME}
var game_mode: GameMode = GameMode.NONE

func _ready():
	game_mode = GameMode.MENU
	$World.get_node("Control/CanvasLayer").visible = false
	$World.process_mode = Node.PROCESS_MODE_DISABLED
	$GUI/MainMenu.play_button_pressed.connect(_on_play_button_pressed)
	$GUI/MainMenu.resume_button_pressed.connect(_toggle_menu)
	_update_window_resolution()

func _process(delta: float) -> void:
	if game_mode == GameMode.GAME && Input.is_action_just_pressed("menu_action"):
		_toggle_menu()

func _toggle_menu() -> void:
		get_tree().paused = !get_tree().paused
		$GUI.visible = get_tree().paused
		$World.get_node("Control/CanvasLayer").visible = !get_tree().paused
		$GUI.process_mode = Node.PROCESS_MODE_ALWAYS

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
	$GUI/MainMenu/CenterContainer/MainButtonContainer/ResumeButton.visible = true
	$GUI/MainMenu/CenterContainer/MainButtonContainer/PlayButton.visible = false
	$GUI.visible = false
	game_mode = GameMode.GAME

func _on_world_world_started(time: Variant, gold: Variant, cool: Variant) -> void:
	print(time)
	print(gold)
	print(cool)
	pass # Replace with function body.
