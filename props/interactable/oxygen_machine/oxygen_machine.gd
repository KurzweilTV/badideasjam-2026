class_name OxygenMachine
extends Interactable


func _on_interact(_interactor: Player) -> bool:
	print("Oxygen Refilled - Cooldown: (%s seconds)" % cooldown_time)
	_interactor.give_oxygen(100)
	return true
