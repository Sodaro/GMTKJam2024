extends Node2D

class_name BuildingGrid

var grid_node_scene: Resource = load("res://building/grid_node.tscn")

var cols: int = 20
var rows: int = 15

var x_offset: int = 8
var y_offset: int = 8
var node_size: int = 16

var grid_nodes: Array[GridNode]

func _ready() -> void:
	_generate_grid()

func _generate_grid() -> void:
	grid_nodes.resize(rows * cols)
	for i in rows * cols:
		var x: int = i % cols
		var y: int = i / cols
		var instance: GridNode = grid_node_scene.instantiate()
		instance.position = Vector2(x * node_size, y * node_size)
		add_child(instance)
		grid_nodes[i] = instance

func get_grid_node_at_mouse() -> GridNode:
	var mouse_pos:Vector2 = get_global_mouse_position()
	var snapped_mouse_pos:Vector2

	if mouse_pos.x > 0:
		snapped_mouse_pos.x = clampf(roundf(mouse_pos.x / node_size), 0, cols - 1)

	if mouse_pos.y > 0:
		snapped_mouse_pos.y = clampf(roundf(mouse_pos.y / node_size), 0, rows - 1)

	var mouse_cell:int = snapped_mouse_pos.y * cols + snapped_mouse_pos.x
	mouse_cell = clampi(mouse_cell, 0, grid_nodes.size()-1)
	return grid_nodes[mouse_cell]
