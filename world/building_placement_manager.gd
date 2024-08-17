extends Node2D

@onready var _building_grid: BuildingGrid = $BuildingGrid

var hovered_node: GridNode
var previous_node: GridNode

enum BuildMode {BUILD, SELL, SELECT}

var mode: BuildMode = BuildMode.BUILD

var building_scene:Resource = load("res://building/building.tscn")

func _process(_delta: float) -> void:
	previous_node = hovered_node
	hovered_node = _building_grid.get_grid_node_at_mouse()
	_update_node_highlights()
	if Input.is_key_pressed(KEY_1):
		mode = BuildMode.BUILD
	elif Input.is_key_pressed(KEY_2):
		mode = BuildMode.SELL
	elif Input.is_key_pressed(KEY_3):
		mode = BuildMode.SELECT

	if hovered_node.is_locked():
		return

	if !Input.is_action_pressed("primary_action"):
		return

	match mode:
		BuildMode.SELECT:
			pass
		BuildMode.BUILD:
			if !hovered_node.has_building():
				hovered_node.build(building_scene)
				$PlaceTowerAudioPlayer.play()
			pass
		BuildMode.SELL:
			if hovered_node.has_building():
				hovered_node.sell_building()
				$SellTowerAudioPlayer.play()
			pass

	_update_node_highlights()

func _update_node_highlights() -> void:
	if previous_node != null && previous_node != hovered_node:
		previous_node.clear_highlight()
	if hovered_node:
		hovered_node.show_highlight()
