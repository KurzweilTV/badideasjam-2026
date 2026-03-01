extends Control


func _on_button_pressed() -> void:
	print("Loading next scene...")
	SceneManager.change_scene("res://scenes/testing/scene2.tscn")
