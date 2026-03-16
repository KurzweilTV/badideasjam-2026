class_name StationDoor
extends Interactable

enum KEYS {None, Green, Blue, Orange}

@export var required_access: KEYS = KEYS.None
@export var start_open: bool = false
@export var door_broken: bool = false
@export var needs_crowbar: bool = false
@export var needs_power: bool = true

var auto_close_time: float = 4.0
var door_open: bool = false
var first_interaction: bool = true

@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer

func _ready() -> void:
	StationStatus.station_power_change.connect(_set_powerup_state)
	if door_broken: 
		anim.play("broken")
		%DoorInteract.disabled = true
	if start_open:
		%DoorInteract.disabled = true
	else:
		close_door()
		
func _on_interact(interactor: Player) -> bool:
	if needs_power and not StationStatus.station_powered:
		$DoorLocked.play()
		print("Powerup the station first")
		if first_interaction:
			print("First time clicking door")
			first_interaction = false
		return false

	if needs_crowbar and not interactor.has_crowbar:
		$DoorLocked.play()
		if first_interaction:
			play_crowbar_dialog()
			first_interaction = false
		return false

	if door_open:
		close_door()
	else:
		open_door(interactor)

		if needs_crowbar:
			interactor.set_crowbar(false) # This makes the crowbar consumable
			#TODO Play breaking sound for losing the crowbar
		else:
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
		$AccessError.play()
		print("Needs %s Key" % required_access)
		
func close_door() -> void:
	anim.play("door_close")
	$DoorClose.play()
	door_open = false

func play_crowbar_dialog() -> void:
	StationStatus.dialog.emit(
		"I bet I could open this with a [color=pale_violet_red]crowbar[/color].",
		0.5,
		StationStatus.player_color,
		false,
		"dialog_05.mp3"
	)

func _set_powerup_state(status) -> void:
	if door_broken: return
	needs_crowbar = !status
	needs_power = status
	%DoorInteract.disabled = false
	close_door()
