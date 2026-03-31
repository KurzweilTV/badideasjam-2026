class_name OptionsMenu
extends Control

signal options_saved

@onready var hover: AudioStreamPlayer = %Hover
@onready var click: AudioStreamPlayer = %Click
@onready var fullscreen: CheckButton = %Fullscreen
@onready var quit_game: Button = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/QuitGame

func _ready() -> void:
	if SceneManager.game_mode:
		quit_game.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		_on_save_close_pressed()
		get_viewport().set_input_as_handled()

func _on_save_close_mouse_entered() -> void:
	hover.play()

func _on_save_close_pressed() -> void:
	print("Closing Options")
	options_saved.emit()
	if SceneManager.game_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	queue_free()

func _on_tab_container_tab_selected(_tab: int) -> void:
	if is_instance_valid(click):
		click.play()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_quit_game_pressed() -> void:
	get_tree().quit()
