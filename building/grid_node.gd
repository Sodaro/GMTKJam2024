extends Node2D

class_name GridNode

var _is_locked: bool = false
var _has_building: bool = false
var _building: Building = null
var _building_resource: BuildingResource = null

@export var _hover_empty_color := Color.GREEN
@export var _hover_building_color := Color.RED
@export var _locked_color := Color.DIM_GRAY
@export var _default_color := Color.WHITE

func build(building_resource: BuildingResource) -> void:
	_has_building = true
	_building_resource = building_resource
	_building = _building_resource.building_scene.instantiate()
	add_child(_building)
	_building.position = Vector2(0, 0)

func remove_building() -> void:
	_has_building = false
	assert(_building != null)
	_building.queue_free()

func get_building_data() -> BuildingResource:
	return _building_resource

func get_building() -> Building:
	return _building

func has_building() -> bool:
	return _has_building

func is_locked() -> bool:
	return _is_locked

func lock() -> void:
	_is_locked = true

func clear_lock() -> void:
	_is_locked = false

func show_highlight(mode: BuildingPlacementManager.BuildMode) -> void:
	if mode == BuildingPlacementManager.BuildMode.SELL && has_building():
		modulate = Color.GOLD
	else:
		modulate = _default_color

	if _is_locked:
		$Sprite2D.visible = false

func clear_highlight() -> void:
	modulate = _default_color
	if _is_locked:
		$Sprite2D.visible = false
