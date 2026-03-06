extends AudioStreamPlayer3D

var tween: Tween

func _ready() -> void:
	StationStatus.station_power_change.connect(_on_powerup)

func _on_powerup(_powered: bool) -> void:
	if tween:
		tween.kill()

	pitch_scale = 0.01
	play()

	tween = create_tween()
	tween.tween_property(self, "pitch_scale", 1.0, 6.0)
