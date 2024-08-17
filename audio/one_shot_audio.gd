extends AudioStreamPlayer2D

class_name OneShotAudio

var lifetime: float

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func play_sound(audio_stream: AudioStream) -> void:
	stream = audio_stream
	lifetime = stream.get_length()
	play()
