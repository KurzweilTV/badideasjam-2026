extends StaticBody3D

var tween: Tween
@onready var sound: AudioStreamPlayer3D = $Sound
@onready var particles: CPUParticles3D = $CPUParticles3D

func _ready() -> void:
	StationStatus.station_power_change.connect(_on_powerup)

func _on_powerup(powered: bool) -> void:
	if tween:
		tween.kill()
	
	particles.emitting = powered
	sound.pitch_scale = 0.01
	sound.play()

	tween = create_tween()
	tween.tween_property(sound, "pitch_scale", 1.0, 10.0)
