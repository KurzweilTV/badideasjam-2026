class_name LightsOutSwitch
extends Interactable

enum switch_positions {A, B, C, D}

@export var switch_position: switch_positions
@export var staring_status: bool

var current_status: bool

@onready var anim: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	StationStatus.toggled_powerup_switch.connect(check_switch)
	toggle_switch(staring_status)

func _on_interact(_interactor: Player) -> bool:
	var new_state = !current_status
	toggle_switch(new_state)
	StationStatus.handle_power_switches(switch_position)
	return true

func check_switch(index: int) -> void:
	var new_state = !current_status
	current_status = new_state
	if index == switch_position:
		toggle_switch(new_state)

func toggle_switch(status: bool) -> void:
	current_status = status
	if status:
		anim.play("turn_on")
	else:
		anim.play("turn_off")
