class_name OxygenMachine
extends Interactable

@onready var use_sound: AudioStreamPlayer3D = $UseSound
@onready var body: MeshInstance3D = $blockbench_export/body

func _on_interact(_interactor: Player) -> bool:
	print("Oxygen Refilled - Cooldown: (%s seconds)" % cooldown_time)
	use_sound.pitch_scale = randf_range(0.9, 1.1)
	use_sound.play()
	_interactor.give_oxygen(100)
	return true
