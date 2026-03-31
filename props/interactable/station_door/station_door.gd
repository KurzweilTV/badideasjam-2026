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
## Only used for the power room door
@export var visual_crowbar: Node3D = null

var auto_close_time: float = 4.0
var door_open: bool = false
var first_interaction: bool = true

@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer

func _ready() -> void:
	StationStatus.id_card_used.connect(_on_idcard_used)
	StationStatus.station_power_change.connect(_set_powerup_state)
	if door_broken: 
		anim.play("broken")
		%DoorInteract.disabled = true
	if start_open:
		open_door_instant()
		%DoorInteract.disabled = true
	else:
		close_door_instant()
	if special_elevator_door:
		StationStatus.open_elevator_door.connect(open_elevator)
		StationStatus.close_elevator_door.connect(close_elevator)
		
func _on_interact(interactor: Player) -> bool:
	if door_broken: return false
	
	if special_elevator_door: 
		$DoorLocked.play()
		return false
	if needs_pressureized and not StationStatus.station_oxygenated:
		StationStatus.dialog.emit("Pressureize the Facility First",0,StationStatus.system_color,true)
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
			door_broken = true
			interactor.set_crowbar(false)
			$CrowbarOpen.play()
			%DoorInteract.disabled = true
			anim.play("broken")
			if visual_crowbar:
				delay_show_crowbar()
		else:
			_start_auto_close_timer()
	return true

func delay_show_crowbar() -> void:
	await get_tree().create_timer(1.0).timeout
	visual_crowbar.show()
	
	

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
	
func open_door(_player: Player) -> void:
	if required_access == 0:
		anim.play("door_open")
		$DoorOpen.play()
		door_open = true
	else: 
		$AccessError.play()
		StationStatus.dialog.emit("Locked... Maybe I can open this with an [color=pale_violet_red]ID card[/color].",0.5,StationStatus.player_color,false,"idcard.wav")
		
func close_door() -> void:
	if not door_open:
		return
	anim.play("door_close")
	$DoorClose.play()
	door_open = false

func open_door_instant() -> void:
	anim.play("door_open")
	anim.seek(anim.current_animation_length, true)
	door_open = true

func close_door_instant() -> void:
	anim.play("door_close")
	anim.seek(anim.current_animation_length, true)
	door_open = false

func play_crowbar_dialog() -> void:
	StationStatus.try_power_door()
	StationStatus.dialog.emit(
		"I bet I could open this with a [color=pale_violet_red]crowbar[/color].",
		0.5,
		StationStatus.player_color,
		false,
		"crowbar.wav"
	)

func _set_powerup_state(status) -> void:
	if door_broken:
		%DoorInteract.disabled = true
		return
	needs_crowbar = !status
	needs_power = status
	%DoorInteract.disabled = false
	close_door()

func _on_idcard_used() -> void:
	if required_access > 0:
		required_access = KEYS.None
