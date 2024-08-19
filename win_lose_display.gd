extends Control

signal on_play_again_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_end_menu()

func hide_end_menu() -> void:
	visible = false

func show_end_menu(is_win: bool) -> void:
	%VictoryDisplay.visible = is_win
	%DefeatDisplay.visible = !is_win
	visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	on_play_again_pressed.emit()
