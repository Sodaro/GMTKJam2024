extends Node2D

class_name BuildingPlacementManager

@onready var _building_grid: BuildingGrid = $BuildingGrid
@onready var WORLD: Node = get_parent()

signal building_purchased(building_data: BuildingResource)
signal building_sold(building_data: BuildingResource)

var hovered_node: GridNode
var previous_node: GridNode

enum BuildMode {NONE, BUILD, SELL}

var mode: BuildMode = BuildMode.NONE

@export var allowed_placement_zones: Array[PlacementZone]
@export var _building_data: BuildingResource

func _ready() -> void:
	$BuildingGrid.generate_grid(allowed_placement_zones)

func enable_build_mode(building_data: BuildingResource) -> void:
	mode = BuildMode.BUILD
	_building_grid.show_grid()
	_building_data = building_data

func enable_sell_mode() -> void:
	mode = BuildMode.SELL
	_building_grid.hide_grid()
	_building_data = null

func exit_current_mode() -> void:
	mode = BuildMode.NONE
	_building_grid.hide_grid()
	_building_data = null

func _process(_delta: float) -> void:
	previous_node = hovered_node
	hovered_node = _building_grid.get_grid_node_at_mouse()
	_update_node_highlights()

	if hovered_node.is_locked():
		$PlacementPreview.visible = false
		return

	if _building_data != null && !hovered_node.has_building() && mode == BuildMode.BUILD:
		$PlacementPreview.visible = true
		$PlacementPreview.texture = _building_data.display_texture
		$PlacementPreview.global_position = hovered_node.global_position
	else:
		$PlacementPreview.visible = false

	_update_node_highlights()

	if !Input.is_action_pressed("primary_action"):
		return

	match mode:
		BuildMode.NONE:
			pass
		BuildMode.BUILD:
			if !hovered_node.has_building() && %EconomyManager.can_purchase_building(_building_data):
				hovered_node.build(_building_data)
				building_purchased.emit(_building_data)
				$PlaceTowerAudioPlayer.play()

			pass
		BuildMode.SELL:
			if hovered_node.has_building():
				building_sold.emit(hovered_node.get_building_data())
				hovered_node.remove_building()
				$SellTowerAudioPlayer.play()
			pass

func _update_node_highlights() -> void:
	if previous_node != null && previous_node != hovered_node:
		previous_node.clear_highlight()
	if hovered_node:
		hovered_node.show_highlight(mode)
