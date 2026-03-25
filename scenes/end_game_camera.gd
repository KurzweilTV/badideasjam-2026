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
		"…surface……it said… surface… …this isn’t… home… …this is wrong… …no one… Everyone is... gone.. I'm going to die inside this metal box...",
		5.0,
		StationStatus.player_color,
		false,
		"temp_monolog.mp3")
	dispair_cue.play()
	await dispair_cue.finished
	SceneManager.change_scene("res://scenes/end_credits/credits_background.tscn")
