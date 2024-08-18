extends Node2D

class_name BuildingPlacementManager

@onready var _building_grid: BuildingGrid = $BuildingGrid

signal building_purchased(building_data: BuildingResource)
signal building_sold(building: Building)

var hovered_node: GridNode
var previous_node: GridNode

enum BuildMode {BUILD, SELL, SELECT}

var mode: BuildMode = BuildMode.BUILD

@export var allowed_placement_zones: Array[PlacementZone]
@export var building_data: BuildingResource

func _ready() -> void:
	$BuildingGrid.generate_grid(allowed_placement_zones)

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

	if hovered_node.is_locked() || mode != BuildMode.BUILD:
		$PlacementPreview.visible = false

	if building_data != null && !hovered_node.has_building() && mode == BuildMode.BUILD:
		$PlacementPreview.visible = true
		$PlacementPreview.texture = building_data.display_texture
		$PlacementPreview.global_position = hovered_node.global_position

	_update_node_highlights()

	if !Input.is_action_pressed("primary_action"):
		return

	match mode:
		BuildMode.SELECT:
			pass
		BuildMode.BUILD:
			if !hovered_node.has_building() && %EconomyManager.can_purchase_building(building_data):
				hovered_node.build(building_data)
				building_purchased.emit(building_data)
				$PlaceTowerAudioPlayer.play()

			pass
		BuildMode.SELL:
			if hovered_node.has_building():
				building_sold.emit(hovered_node.get_building())
				hovered_node.remove_building()
				$SellTowerAudioPlayer.play()
			pass



func _update_node_highlights() -> void:
	if previous_node != null && previous_node != hovered_node:
		previous_node.clear_highlight()
	if hovered_node:
		hovered_node.show_highlight(mode)
