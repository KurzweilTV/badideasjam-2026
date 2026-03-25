extends Area3D

@export var show_terrain: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if show_terrain:
			SceneManager.show_terrain.emit()
