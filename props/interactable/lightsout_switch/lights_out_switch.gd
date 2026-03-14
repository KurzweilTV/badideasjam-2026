class_name LightsOutSwitch
extends Interactable

enum switch_positions {A, B, C, D}

@export var switch_position: switch_positions
@export var staring_status: bool

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var switch_sound: AudioStreamPlayer3D = %SwitchSound

func _ready() -> void:
	StationStatus.toggled_powerup_switch.connect(check_switch)
	StationStatus.switches[switch_position] = staring_status
	StationStatus.station_power_change.connect(_on_station_powerup)
	apply_visual(staring_status)

func _on_interact(_interactor: Player) -> bool:
	StationStatus.toggle_switch(switch_position)
	StationStatus.handle_power_switches(switch_position)
	return true

func check_switch(index: int) -> void:
	if index != switch_position:
		return

	apply_visual(StationStatus.switches[switch_position])

func apply_visual(status: bool) -> void:
	if status:
		anim.play("turn_on")
		await anim.animation_finished
		switch_sound.play()
	else:
		anim.play("turn_off")
		await anim.animation_finished
		switch_sound.play()

		
func _on_station_powerup(_powered) -> void:
	collision.disabled = true
