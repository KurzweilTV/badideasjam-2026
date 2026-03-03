class_name FootstepManager
extends Node3D

@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer
var footstep_sounds := [
preload("res://characters/player/sounds/step1.wav"),
preload("res://characters/player/sounds/step2.wav"),
preload("res://characters/player/sounds/step3.wav"),
preload("res://characters/player/sounds/step4.wav"),
preload("res://characters/player/sounds/step5.wav"),
]

func play_footstep() -> void:
	footstep_player.stream = footstep_sounds.pick_random()
	footstep_player.play()
