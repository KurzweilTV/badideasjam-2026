class_name StationDoor
extends Interactable

enum KEYS {None, Green, Blue, Orange}

@export var required_access: KEYS = KEYS.None
@export var start_open: bool = false
@export var door_broken: bool = false
@export var needs_crowbar: bool = false
@export var needs_power: bool = true
@export var needs_pressureized: bool = false
## Only used for the final elevator door
@export var special_elevator_door: bool = false

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
	if special_elevator_door:
		StationStatus.open_elevator_door.connect(open_elevator)
		StationStatus.close_elevator_door.connect(close_elevator)
		
func _on_interact(interactor: Player) -> bool:
	if special_elevator_door: 
		$DoorLocked.play()
		return false
	if needs_pressureized and not StationStatus.station_oxygenated:
		StationStatus.dialog.emit("Pressureize the Station First",0,StationStatus.system_color,true)
		return false
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
			#TODO Play metal sound for using the crowbar
		else:
			_start_auto_close_timer()

	return true

func _start_auto_close_timer() -> void:
	auto_close()

func auto_close() -> void:
	await get_tree().create_timer(auto_close_time).timeout
	if door_open:
		close_door()
	
func open_elevator() -> void:
	print("Opening Elevator")
	anim.play("door_open")
	%DoorInteract.disabled = true
	$DoorOpen.play()
	door_open = true
	
func close_elevator() -> void:
	print("Closing Elevator")
	anim.play("door_close")
	$DoorClose.play()
	door_open = false
	
func open_door(player: Player) -> void:
	if player.access_level >= required_access:
		anim.play("door_open")
		$DoorOpen.play()
		door_open = true
	else: 
		$AccessError.play()
		StationStatus.dialog.emit("No access... I need to find an [color=pale_violet_red]employee ID [/color]card.",0.5,StationStatus.player_color,false)
		
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
