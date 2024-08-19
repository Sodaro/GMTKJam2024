extends Control

signal on_play_again_pressed

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#hide_end_menu()

func hide_end_menu() -> void:
	visible = false

func show_end_menu(is_win: bool, wave_data: WaveManager.WaveData) -> void:
	Globals.WORLD.process_mode = PROCESS_MODE_DISABLED
	%VictoryDisplay.visible = is_win
	%DefeatDisplay.visible = !is_win
	if is_win:
		%SurvivedLevelsLabel.text = "Survived 12/12 Levels"
	else:
		%SurvivedLevelsLabel.text = "Survived %d/12 Levels" % (wave_data.wave_number - 1)
	visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	on_play_again_pressed.emit()
