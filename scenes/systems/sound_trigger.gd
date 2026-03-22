class_name SoundTrigger
extends Area3D

const METAL_DROP = preload("uid://dskeqcmh0omy0")
const METAL_RATTLE = preload("uid://b0cx2r21van4q")

enum SoundType {
	METAL_DROP,
	METAL_RATTLE
}

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var sound: AudioStreamPlayer3D = $Sound

@export var one_shot: bool = true
@export var trigger_zone: Shape3D
@export var sound_type: SoundType = SoundType.METAL_DROP

func _ready() -> void:
	if trigger_zone:
		collision_shape_3d.shape = trigger_zone

	match sound_type:
		SoundType.METAL_DROP:
			sound.stream = METAL_DROP
		SoundType.METAL_RATTLE:
			sound.stream = METAL_RATTLE

func _on_body_entered(body: Node3D) -> void:
	if body is Player and one_shot:
		sound.play()
		one_shot = false
