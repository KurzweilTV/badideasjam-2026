extends SpotLight3D

@onready var click: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("flashlight"):
		self.visible = !self.visible
		if visible:
			click.pitch_scale = 2.0
			click.play()
		else: 
			click.pitch_scale = 1.5
			click.play()
