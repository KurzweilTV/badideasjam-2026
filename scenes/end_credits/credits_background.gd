extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneManager.set_game_mode(false)
	credits_complete()
	

func _on_skip_pressed() -> void:
	SceneManager.change_scene("uid://btpe1nrboepgg") # Main Menu Scene

func credits_complete() -> void:
	await get_tree().create_timer(45).timeout
	_on_skip_pressed()
