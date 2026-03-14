# Global.gd (autoload)
extends Node

signal toggled_powerup_switch(index: int)
signal station_power_change(powered: bool)
signal station_color_change(new_color: Color)
@warning_ignore("unused_signal")
signal dialog(message: String, delay: float, border_color: Color, tutorial: bool)
@warning_ignore("unused_signal")
signal dialog_complete

@export_category("Dialog Box Colors")
@export var player_color: Color = Color.PALE_GREEN
@export var system_color: Color = Color.PINK

## Powerup switch status
var switch_a: bool
var switch_b: bool
var switch_c: bool
var switch_d: bool

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

func toggle_switch(index) -> void:
	print("Toggling: %s" % str(index))
	toggled_powerup_switch.emit(index)

func set_station_color(new_color: Color) -> void:
	station_color = new_color
	station_color_change.emit(new_color)

func set_station_power(powered: bool) -> void:
	station_powered = powered
	station_power_change.emit(powered)
