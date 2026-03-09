extends CPUParticles3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var static_sound: AudioStreamPlayer3D = $StaticSound

func _ready() -> void:
	_flicker()
	StationStatus.station_power_change.connect(_on_station_power_up)

func _on_station_power_up(status: bool) -> void:
	self.emitting = status
	omni_light_3d.visible = status
	static_sound.play()
	
func _flicker() -> void:
	while true:
		var wait_time := randf_range(0.0, 0.4)
		var target_energy := randf_range(0.1, 1.2)

		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(omni_light_3d, "light_energy", target_energy, wait_time)

		await tween.finished
