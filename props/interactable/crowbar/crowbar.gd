extends Pickup

func _on_interact(_interactor: Player) -> bool:
	_interactor.set_crowbar(true)
	self.queue_free()
	return true
