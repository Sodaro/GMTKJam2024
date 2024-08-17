@tool
extends Node2D

class_name PlacementZone

@export_range(0, 40, 1) var width_tiles: int = 1
@export_range(0, 40, 1) var height_tiles: int = 1


func get_rect() -> Rect2:
	var width: float = width_tiles * 16
	var height: float = height_tiles * 16
	return Rect2(global_position.x + (width * -0.5), global_position.y + (height * -0.5), width, height)

func _ready() -> void:
	var width: float = width_tiles * 16
	var height: float = height_tiles * 16

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		return
	queue_redraw()

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	var width: float = width_tiles * 16
	var height: float = height_tiles * 16
	draw_rect(Rect2(width * -0.5, height * -0.5, width, height), Color.GREEN)
