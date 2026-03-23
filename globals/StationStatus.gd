# Global.gd (autoload)
extends Node

signal toggled_powerup_switch(index: int)
signal station_power_change(powered: bool)
signal station_oxygen_on
signal station_color_change(new_color: Color)
signal got_oxygen_mask
signal open_elevator_door
signal close_elevator_door
signal dialog(message: String, delay: float, border_color: Color, tutorial: bool)
signal dialog_complete
signal elevator_arrived
signal elevator_moving
signal elevator_complete

@export_category("Dialog Box Colors")
@export var player_color: Color = Color.PALE_GREEN
@export var system_color: Color = Color.PINK

## Powerup switch status
var switches := [false, true, false, true]

var station_oxygenated: bool = false
var station_powered: bool = false
var station_color: Color = Color.RED

func handle_power_switches(index: int) -> void:
	print("Toggled Switch: %s" % str(index))

	match index:
		0:
			toggle_switch(3)
			#toggle_switch(0)
			toggle_switch(1)

		1:
			toggle_switch(0)
			#toggle_switch(1)
			toggle_switch(2)

		2:
			toggle_switch(1)
			#toggle_switch(2)
			toggle_switch(3)

		3:
			toggle_switch(2)
			#toggle_switch(3)
			toggle_switch(0)

func toggle_switch(index: int) -> void:
	switches[index] = !switches[index]
	toggled_powerup_switch.emit(index)
	check_switches_complete()

func check_switches_complete() -> void:
	await get_tree().create_timer(0.5).timeout
	if switches[0] and switches[1] and switches[2] and switches[3]:
		set_station_power(true)
		set_station_color(Color.WHITE)
		station_power_change.emit(true)


func set_station_oxygenated() -> void:
	station_oxygenated = true

func set_station_color(new_color: Color) -> void:
	station_color = new_color
	station_color_change.emit(new_color)

func set_station_power(powered: bool) -> void:
	station_powered = powered
	set_station_color(Color.WHITE)
	station_power_change.emit(powered)
	
