extends TextureButton

@export var tower_resource : BuildingResource
signal tower_clicked(tower_resource: BuildingResource)

func _ready() -> void:
	texture_normal = tower_resource.display_texture
	texture_hover = tower_resource.hover_texture
	texture_pressed = tower_resource.pressed_texture
	button_down.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	Input.action_release("primary_action")
	%BuildingPlacementManager.enable_build_mode(tower_resource)
	tower_clicked.emit(tower_resource)
