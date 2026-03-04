class_name OxygenMachine
extends Interactable

@onready var use_sound: AudioStreamPlayer3D = $UseSound


func _on_interact(_interactor: Player) -> bool:
	print("Oxygen Refilled - Cooldown: (%s seconds)" % cooldown_time)
	use_sound.play()
	_interactor.give_oxygen(100)
	return true
