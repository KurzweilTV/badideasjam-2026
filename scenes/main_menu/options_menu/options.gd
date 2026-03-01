class_name OptionsMenu
extends Control

signal options_saved

@onready var hover: AudioStreamPlayer = %Hover
@onready var click: AudioStreamPlayer = %Click

func _on_save_close_mouse_entered() -> void:
	hover.play()

func _on_save_close_pressed() -> void:
	options_saved.emit()
	queue_free()

func _on_tab_container_tab_selected(tab: int) -> void:
	print("Tab Pressed: %s" % tab)
	if is_instance_valid(click):
		click.play()
