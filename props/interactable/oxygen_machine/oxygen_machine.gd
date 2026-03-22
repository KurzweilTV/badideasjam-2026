class_name OxygenMachine
extends Interactable

@export var tutorial_machine: bool = false
@onready var use_sound: AudioStreamPlayer3D = $UseSound
@onready var body: MeshInstance3D = $blockbench_export/body
var first_interaction: bool = true

func _on_interact(_interactor: Player) -> bool:
	use_sound.pitch_scale = randf_range(0.9, 1.1)
	use_sound.play()
	_interactor.give_oxygen(100)
	if first_interaction and tutorial_machine: 
		StationStatus.dialog.emit("Good... I can fill my [color=green]oxygen[/color] up here.", 1, StationStatus.player_color, false, "dialog_08.mp3")
		first_interaction = false
	return true
