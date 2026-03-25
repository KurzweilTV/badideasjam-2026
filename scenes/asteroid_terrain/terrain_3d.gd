extends Terrain3D

func _ready() -> void:
	SceneManager.show_terrain.connect(_on_show_terrain)
	
func _on_show_terrain() -> void:
	self.show()
