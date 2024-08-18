extends Node

@export var menu_song : AudioStreamMP3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_play_menu_audio()
	
	pass # Replace with function body.

func _play_menu_audio() -> void:
	$AudioStreamPlayer2D.stream = menu_song
	$AudioStreamPlayer2D.autoplay = true
	$AudioStreamPlayer2D.bus = "Music"
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
