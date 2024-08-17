extends Node2D

class_name GridNode

var _is_locked: bool = false
var _has_building: bool = false
var _building: Building = null

@export var _hover_empty_color = Color.GREEN
@export var _hover_building_color = Color.RED
@export var _locked_color = Color.DIM_GRAY
@export var _default_color = Color.TRANSPARENT

func build(building_scene: Resource):
	assert(_building == null)
	_has_building = true
	_building = building_scene.instantiate()
	add_child(_building)
	_building.global_position = position

func sell_building():
	_has_building = false
	assert(_building != null)
	_building.queue_free()

func has_building():
	return _has_building

func is_locked():
	return _is_locked

func lock():
	_is_locked = true

func clear_lock():
	_is_locked = false

func show_highlight():
	if _is_locked:
		modulate = _locked_color
	elif _has_building:
		modulate = _hover_building_color
	else:
		modulate = _hover_empty_color

func clear_highlight():
	if _is_locked:
		modulate = _locked_color
	else:
		modulate = Color.WHITE
		$Sprite2D.self_modulate = _default_color
