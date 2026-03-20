extends Interactable

@onready var sound: AudioStreamPlayer3D = get_node_or_null("Sound")

func _on_interact(interactor: Player) -> bool:
	interactor.set_oxygen(42)
	interactor.enable_oxygen()
	StationStatus.got_oxygen_mask.emit()
	hide()

	if sound:
		sound.pitch_scale = randf_range(0.9, 1.1)
		sound.play()
		delayed_cleanup()
	else:
		queue_free()

	return true

func delayed_cleanup() -> void:
	if sound:
		await sound.finished
	queue_free()
