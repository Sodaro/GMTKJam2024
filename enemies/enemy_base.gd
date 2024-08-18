extends PathFollow2D

class_name BaseEnemy

var health: float = 10.0

@export var _monster_resource: MonsterResource
@export var death_sfx: AudioStream
var audio_one_shot_scene: Resource = preload("res://audio/one_shot_audio.tscn")

signal enemy_killed(monster_resource: MonsterResource)
signal reached_castle(enemy: BaseEnemy)

enum DamageType {PIERCING, FIRE}

var _registered_components: Dictionary

func register_component(component: Variant):
	_registered_components[typeof(component)] = component
#
func get_component(component: Variant):
	var type = typeof(component)
	if _registered_components.has(type):
		return _registered_components[type]
	return null

func initialize(in_monster_resource: MonsterResource):
	_monster_resource = in_monster_resource
	$Sprite2D.texture = _monster_resource.display_texture
	health = _monster_resource.max_health
	$HealthBar.max_value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * _monster_resource.move_speed
	if progress_ratio >= 1.0:
		reached_castle.emit(self)
		queue_free()

func take_damage(amount: float, type: DamageType) -> void:
	if health <= 0:
		return
	var actual_amount: float = amount
	match (type):
		DamageType.PIERCING:
			actual_amount *= _monster_resource.piercing_damage_modifier
		DamageType.FIRE:
			actual_amount *= _monster_resource.fire_damage_modifier
	health -= actual_amount
	$HealthBar.value = health
	if health <= 0:
		enemy_killed.emit(_monster_resource)
		var audio_one_shot: OneShotAudio = audio_one_shot_scene.instantiate()
		get_tree().get_root().add_child(audio_one_shot)
		audio_one_shot.play_sound(death_sfx)
		queue_free()
