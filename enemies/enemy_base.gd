extends PathFollow2D

class_name BaseEnemy

var health: float = 10.0

@export var death_sfx: AudioStream
var audio_one_shot_scene: Resource = preload("res://audio/one_shot_audio.tscn")

signal reached_castle(enemy: BaseEnemy)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * 50
	if progress_ratio >= 1.0:
		reached_castle.emit(self)
		queue_free()

func take_damage(amount: float) -> void:
	health -= amount
	$ProgressBar.value = health
	if health <= 0:
		var audio_one_shot: OneShotAudio = audio_one_shot_scene.instantiate()
		get_tree().get_root().add_child(audio_one_shot)
		audio_one_shot.play_sound(death_sfx)
		queue_free()
