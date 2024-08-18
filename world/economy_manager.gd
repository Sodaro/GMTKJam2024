extends Node

signal on_gold_changed(new_gold : int)

var _current_gold: int = 10

@onready var _building_placement_manager: BuildingPlacementManager = %BuildingPlacementManager
@onready var _wave_manager: WaveManager = %WaveManager

func _ready() -> void:
	_building_placement_manager.building_purchased.connect(_on_building_purchased)
	_building_placement_manager.building_sold.connect(_on_building_sold)
	_wave_manager.on_enemy_spawned.connect(_on_enemy_spawned)
	_update_gold_display()

func _on_enemy_spawned(enemy: BaseEnemy) -> void:
	enemy.enemy_killed.connect(_on_enemy_killed)

func _on_building_purchased(building_data: BuildingResource) -> void:
	_current_gold -= building_data.gold_cost
	_update_gold_display()

func _on_building_sold(building: Building) -> void:
	_current_gold += building.get_sell_value()
	_update_gold_display()

func _update_gold_display() -> void:
	on_gold_changed.emit(_current_gold)
	#%GoldLabel.text = "Gold: " + str(_current_gold)

func _on_enemy_killed(monster_resource: MonsterResource) -> void:
	_current_gold += monster_resource.gold_value
	_update_gold_display()

func can_purchase_building(building_data: BuildingResource) -> bool:
	return building_data && _current_gold >= building_data.gold_cost
