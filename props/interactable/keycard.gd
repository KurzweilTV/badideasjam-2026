class_name Keycard
extends Interactable

enum KEYS {None, Green, Blue, Orange}

@export var access_given: KEYS = KEYS.Green

func _on_interact(_interactor: Player) -> bool:
	_interactor.set_access(access_given)
	id_pickup_dialog()
	queue_free()
	return true

func id_pickup_dialog() -> void:
	StationStatus.dialog.emit(
		"Now I can get into the[color=green]atmosphere control [/color]room.",
		0.5,
		StationStatus.player_color,
		false,
		"atmosphere.wav"
	)
