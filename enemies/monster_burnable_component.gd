extends MonsterComponent
class_name MonsterBurnableComponent

var _burn_timer: float = 0
var _burn_damage: float = 0

func burn(burn_damage: float, duration: float) -> void:
	$FlameSprite.visible = true
	set_process(true)
	_burn_timer = duration
	_burn_damage = burn_damage
	monster.take_damage(_burn_damage * get_process_delta_time(), BaseEnemy.DamageType.FIRE)

func _process(delta: float) -> void:
	_burn_timer -= delta
	monster.take_damage(_burn_damage * delta, BaseEnemy.DamageType.FIRE)
	if _burn_timer <= 0:
		$FlameSprite.visible = false
		set_process(false)
