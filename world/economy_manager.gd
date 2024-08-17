extends Node

var _current_gold: int = 10

@onready var _building_placement_manager:BuildingPlacementManager = %BuildingPlacementManager

func _ready() -> void:
	_building_placement_manager.building_purchased.connect(_on_building_purchased)
	_building_placement_manager.building_sold.connect(_on_building_sold)

func _on_building_purchased(building_data: BuildingResource) -> void:
	_current_gold -= building_data.gold_cost
	_update_gold_display()

func _on_building_sold(building: Building) -> void:
	_current_gold += building.get_sell_value()
	_update_gold_display()

func _update_gold_display() -> void:
	pass
	#%GoldLabel.text = "Gold: " + str(_current_gold)

func can_purchase_building(building_data: BuildingResource) -> bool:
	return _current_gold >= building_data.gold_cost
