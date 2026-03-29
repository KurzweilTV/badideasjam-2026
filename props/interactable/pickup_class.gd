class_name Pickup
extends Interactable

@onready var sound: AudioStreamPlayer3D = get_node_or_null("Sound")

func _on_interact(_interactor: Player) -> bool:
	_interactor.give_oxygen(35)
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
