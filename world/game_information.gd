extends VFlowContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%WaveManager.on_level_changed.connect(_on_level_changed)
	%EconomyManager.on_gold_changed.connect(_on_gold_changed)

func _on_level_changed(new_level : int) -> void:
	%LevelLabel.text = str(new_level)
	
func _on_gold_changed(new_gold : int) -> void:
	%GoldLabel.text = str(new_gold)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
