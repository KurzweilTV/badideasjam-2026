class_name Pickup
extends Interactable

func _on_interact(_interactor: Player) -> bool:
	_interactor.give_oxygen(40)
	queue_free()
	return true
