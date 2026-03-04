extends SpotLight3D

@onready var click: AudioStreamPlayer3D = $AudioStreamPlayer3D

var is_on: bool = false

func _ready() -> void:
	light_energy = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight") and not event.is_echo():
		is_on = !is_on

		if is_on:
			click.pitch_scale = 2.0
		else:
			click.pitch_scale = 1.5

		click.play()
		_ramp_energy(is_on)

func _ramp_energy(turn_on: bool) -> void:
	var target: float = 1.5 if turn_on else 0.0
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "light_energy", target, 0.12)
