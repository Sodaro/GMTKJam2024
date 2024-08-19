extends Node

@export var menu_song : AudioStreamMP3
@export var game_songs : Array[AudioStreamMP3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%GUI/MainMenu.play_button_pressed.connect(_start_game_audio)
	_play_menu_audio()

func _play_menu_audio() -> void:
	$AudioStreamPlayer2D.stream = menu_song
	$AudioStreamPlayer2D.autoplay = true
	$AudioStreamPlayer2D.bus = "Music"
	$AudioStreamPlayer2D.play()

func _start_game_audio() -> void:
	if game_songs.is_empty():
		return

	_play_random_game_song()
	$AudioStreamPlayer2D.finished.connect(_play_random_game_song)

func _play_random_game_song() -> void:
	if game_songs.is_empty():
		return

	var random_index = randi() % game_songs.size()
	$AudioStreamPlayer2D.stream = game_songs[random_index]
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
