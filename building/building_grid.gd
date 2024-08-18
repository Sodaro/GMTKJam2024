extends Node2D

class_name BuildingGrid

var grid_node_scene: Resource = load("res://building/grid_node.tscn")

var cols: int = 40
var rows: int = 30

var x_offset: int = 0
var y_offset: int = 0
var node_size: int = 8

var grid_nodes: Array[GridNode]
var valid_grid_nodes: Array[GridNode]

func generate_grid(allowed_placement_zones: Array[PlacementZone]) -> void:
	grid_nodes.resize(rows * cols)
	for i: int in rows * cols:
		var x: int = i % cols
		var y: int = int(i / cols)
		var instance: GridNode = grid_node_scene.instantiate()
		var pos := Vector2(x * node_size + x_offset, y * node_size + y_offset)
		instance.position = pos
		add_child(instance)
		grid_nodes[i] = instance
		var is_locked: bool = true
		for zone in allowed_placement_zones:
			var rect: Rect2 = zone.get_rect()
			if rect.has_point(pos):
				is_locked = false
				break
		if is_locked:
			instance.lock()
		else:
			valid_grid_nodes.push_back(instance)

func show_grid() -> void:
	for grid_node in valid_grid_nodes:
		grid_node.show_node()

func hide_grid() -> void:
	for grid_node in valid_grid_nodes:
		grid_node.hide_node()

func get_grid_node_at_mouse() -> GridNode:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var snapped_mouse_pos: Vector2

	if mouse_pos.x > 0:
		snapped_mouse_pos.x = clampf(roundf(mouse_pos.x / node_size), 0, cols - 1)

	if mouse_pos.y > 0:
		snapped_mouse_pos.y = clampf(roundf(mouse_pos.y / node_size), 0, rows - 1)

	var mouse_cell: int = int(snapped_mouse_pos.y * cols + snapped_mouse_pos.x)
	mouse_cell = clampi(mouse_cell, 0, grid_nodes.size()-1)
	return grid_nodes[mouse_cell]
