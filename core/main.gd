extends Node
class_name Main

enum GameMode {NONE, MENU, GAME}
var game_mode: GameMode = GameMode.NONE

func _ready():
	game_mode = GameMode.MENU
	$World.get_node("Control/CanvasLayer").visible = false
	$World.process_mode = Node.PROCESS_MODE_DISABLED
	#$World.get_node("World/WaveManager").on_level_finished.connect(_display_end_screen_win)
	$GUI/MainMenu.play_button_pressed.connect(_on_play_button_pressed)
	$GUI/WinLoseDisplay.on_play_again_pressed.connect(_on_play_button_pressed)
	$GUI/MainMenu.resume_button_pressed.connect(_display_game)
	$GUI/WinLoseDisplay.on_play_again_pressed.connect(_restart_game)
	_update_window_resolution()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_action"):
		if game_mode == GameMode.MENU:
			var main_menu = $GUI/MainMenu
			if main_menu.get_state() != main_menu.MenuState.MAIN_MENU:
				$GUI/MainMenu.go_to_menu()
			else:
				_display_game()
		else:
			_display_menu()

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

func _display_game() -> void:
	$World.get_node("Control/CanvasLayer").visible = true
	$World.process_mode = Node.PROCESS_MODE_PAUSABLE
	$GUI.process_mode = Node.PROCESS_MODE_DISABLED
	$GUI/MainMenu/CenterContainer/MainButtonContainer/ResumeButton.visible = true
	$GUI/MainMenu/CenterContainer/MainButtonContainer/PlayButton.visible = false
	$GUI.visible = false
	game_mode = GameMode.GAME

func _display_menu() -> void:
	$World.get_node("Control/CanvasLayer").visible = false
	$World.process_mode = Node.PROCESS_MODE_DISABLED
	$GUI.process_mode = Node.PROCESS_MODE_ALWAYS
	$GUI.visible = true
	game_mode = GameMode.MENU

func _display_end_screen_win() -> void:
	$GUI/WinLoseDisplay.show_end_menu()

func _on_play_button_pressed() -> void:
	_display_game()

func _restart_game() -> void:
	_display_game()
	$World/WaveManager.restart()
