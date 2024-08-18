extends HBoxContainer

var _ghost_count: int = 0
var _skeleton_count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%WaveManager.on_level_changed.connect(_on_level_changed)
	%EconomyManager.on_gold_changed.connect(_on_gold_changed)
	%CastleCore.health_changed.connect(_on_health_changed)
	%LifeLabel.text = str(%CastleCore.get_current_heath())
	%LevelLabel.text = str(%WaveManager.get_current_wave_number())
	%BuildingPlacementManager.building_purchased.connect(_on_building_purchased)
	%BuildingPlacementManager.building_sold.connect(_on_building_sold)
	%SnakeLabel.text = "0"
	%SkeletonLabel.text = "0"
	%GhostLabel.text = "0"

func _on_level_changed(new_level : int) -> void:
	%LevelLabel.text = str(new_level)
	%SnakeLabel.text = str(%WaveManager.next_wave_data.base_enemies_to_spawn)

func _on_gold_changed(new_gold : int) -> void:
	%GoldLabel.text = str(new_gold)

func _on_health_changed(new_health : float) -> void:
	%LifeLabel.text = str(new_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_building_purchased(building_resource: BuildingResource):
	match (building_resource.added_enemy_resource.display_name):
		StringName("Ghost"):
			_ghost_count += building_resource.added_enemy_count
		StringName("Skeleton"):
			_skeleton_count += building_resource.added_enemy_count
	%GhostLabel.text = str(_ghost_count)
	%SkeletonLabel.text = str(_skeleton_count)


func _on_building_sold(building_resource: BuildingResource):
	match (building_resource.added_enemy_resource.display_name):
		StringName("Ghost"):
			_ghost_count -= building_resource.added_enemy_count
		StringName("Skeleton"):
			_skeleton_count -= building_resource.added_enemy_count
	%GhostLabel.text = str(_ghost_count)
	%SkeletonLabel.text = str(_skeleton_count)
