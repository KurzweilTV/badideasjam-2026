extends Control

func _on_button_pressed() -> void:
	print("Loading first scene...")
	SceneManager.change_scene("res://scenes/testing/scene1.tscn")
