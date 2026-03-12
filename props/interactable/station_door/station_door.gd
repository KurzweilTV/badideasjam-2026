class_name StationDoor
extends Interactable

enum KEYS {None, Green, Blue, Orange}

@export var required_access: KEYS = KEYS.None
@export var door_lights: bool = true
@export var start_open: bool = false
@export var door_locked: bool = false
@export var needs_crowbar: bool = false
@export var auto_close_time: float = 4.0
var door_open: bool = false
@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer
@onready var strip_lamp: Node3D = $StripLamp
@onready var strip_lamp_2: Node3D = $StripLamp2

func _ready() -> void:
	if not door_lights:
		for lamp: Node3D in [strip_lamp, strip_lamp_2]:
			lamp.visible = false
	if start_open == true:
		%DoorInteract.disabled = true
	else: close_door()
		
func _on_interact(_interactor: Player) -> bool:
	if needs_crowbar and not _interactor.has_crowbar:
		$DoorLocked.play()
		StationStatus.dialog.emit("I bet I could open this with a [color=pale_violet_red]crowbar[/color].", 0.5, StationStatus.player_color)
		return false
	if door_locked: 
		$DoorLocked.play()
		return false
	if door_open:
		close_door()
	else:
		open_door(_interactor)
		if needs_crowbar: %DoorInteract.disabled = true # no need to close a door that we pryed open
		if not needs_crowbar:
			_start_auto_close_timer()
	return true


func _start_auto_close_timer() -> void:
	auto_close()


func auto_close() -> void:
	await get_tree().create_timer(auto_close_time).timeout
	if door_open:
		close_door()
	
func open_door(player: Player) -> void:
	if player.access_level >= required_access:
		anim.play("door_open")
		$DoorOpen.play()
		door_open = true
	else: 
		$DoorLocked.pitch_scale = randf_range(0.9, 1.1)
		$DoorLocked.play()
		print("Needs %s Key" % required_access)
		
func close_door() -> void:
	anim.play("door_close")
	$DoorClose.play()
	door_open = false
