class_name Keycard
extends Interactable

enum KEYS {None, Green, Blue, Orange}

@export var access_given: KEYS = KEYS.Green

func _on_interact(_interactor: Player) -> bool:
	_interactor.set_access(access_given)
	queue_free()
	return true
