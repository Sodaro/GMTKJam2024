extends TextureButton

@export var tower_resource : BuildingResource
signal tower_clicked(tower_resource: BuildingResource)

func _ready() -> void:
	texture_normal = tower_resource.display_texture
	button_down.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	%BuildingPlacementManager.building_data = tower_resource
	tower_clicked.emit(tower_resource)
