extends Control

const OPTIONS_MENU = preload("uid://dlv5mg4wdfaeo")

@onready var hover: AudioStreamPlayer = %Hover
@onready var click: AudioStreamPlayer = %Click
@onready var start_game: AudioStreamPlayer = %StartGame

func _on_button_mouse_entered() -> void: # for any button
	hover.play()

func _on_start_button_pressed() -> void:
	print("Starting Game...")
	SceneManager.change_scene("res://scenes/testing/test_scene.tscn")
	start_game.play()

func _on_options_pressed() -> void:
	var menu := OPTIONS_MENU.instantiate()
	add_child(menu)
	menu.options_saved.connect(click.play)
	click.play()
