class_name Pickup
extends Interactable

@onready var sound: AudioStreamPlayer3D = $Sound

func _on_interact(_interactor: Player) -> bool:
	_interactor.give_oxygen(40)
	self.hide()
	sound.pitch_scale = randf_range(0.9, 1.1)
	sound.play()
	
	delayed_cleanup()
	return true

func delayed_cleanup() -> void:
	await sound.finished
	queue_free()
