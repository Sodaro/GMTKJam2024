extends Control


signal play_button_pressed
signal resume_button_pressed

func _ready():
	%MainButtonContainer/PlayButton.grab_focus()
	%MainButtonContainer/ResumeButton.visible = false
	_deactivate_menu_node($OptionsPanel)

func _process(delta):
	pass

func _activate_menu_node(node:Node) -> void:
	node.visible = true
	node.process_mode = Node.PROCESS_MODE_PAUSABLE

func _deactivate_menu_node(node:Node) -> void:
	node.visible = false
	node.process_mode = Node.PROCESS_MODE_DISABLED

func _on_exit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	play_button_pressed.emit()

func _on_resume_button_pressed():
	resume_button_pressed.emit()

func _on_options_button_pressed():
	$OptionsPanel/VBoxContainer/VBoxContainer/VisualsBoxContainer/DisplayModeContainer/DisplayModeOptionButton.grab_focus()
	_activate_menu_node($OptionsPanel)
	_deactivate_menu_node(%MainButtonContainer)
	_deactivate_menu_node(%LogoContainer)


func _on_options_panel_back_button_pressed():
	%MainButtonContainer/PlayButton.grab_focus()
	_activate_menu_node(%MainButtonContainer)
	_activate_menu_node(%LogoContainer)
	_deactivate_menu_node($OptionsPanel)
