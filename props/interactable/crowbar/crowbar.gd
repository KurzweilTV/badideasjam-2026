extends Pickup

func _on_interact(_interactor: Player) -> bool:
	_interactor.set_crowbar(true)
	#crowbar_pickup_dialog()
	self.queue_free()
	return true

func crowbar_pickup_dialog() -> void:
	StationStatus.dialog.emit(
		"This should help me get into the [color=yellow]power [/color]room.",
		0.5,
		StationStatus.player_color,
		false,
		"crowbarpickup.wav"
	)
