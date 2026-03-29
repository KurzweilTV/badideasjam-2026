extends Camera3D

@onready var dispair_cue: AudioStreamPlayer = %DispairCue
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	StationStatus.start_ending_cinematic.connect(_on_ending_cinematic)
	
	
func _on_ending_cinematic() -> void:
	self.make_current()
	SceneManager.fade_from_black()
	animation_player.play("ending_camera")
	StationStatus.dialog.emit(
		"After weeks of exploring the facility... my fate was clear. 
		Everyone had evacuated to escape an explosion that never came, and I was [color=red]left for dead.[/color]
		With food and water limited.. one thing is certain.. 
		
		I'm going to die inside this metal box.",
		4.0,
		StationStatus.player_color,
		false,
		"epilogue.wav")
	dispair_cue.play()
	await dispair_cue.finished
	SceneManager.change_scene("res://scenes/end_credits/credits_background.tscn")
