class_name OxygenMachine
extends Interactable

@onready var use_sound: AudioStreamPlayer3D = $UseSound
@onready var body: MeshInstance3D = $blockbench_export/body
var first_interaction: bool = true

func _on_interact(_interactor: Player) -> bool:
	use_sound.pitch_scale = randf_range(0.9, 1.1)
	use_sound.play()
	_interactor.give_oxygen(100)
	if first_interaction: 
		StationStatus.dialog.emit("Good... The emergency [color=green]oxygen[/color] still works", 1, StationStatus.player_color, false, "dialog_08.mp3")
		first_interaction = false
	return true
