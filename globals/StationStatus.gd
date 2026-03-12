# Global.gd (autoload)
extends Node

signal station_power_change(powered: bool)
signal station_color_change(new_color: Color)
@warning_ignore("unused_signal")
signal dialog(message: String, delay: float, border_color: Color)
@warning_ignore("unused_signal")
signal dialog_complete

@export_category("Dialog Box Colors")
@export var player_color: Color = Color.PALE_GREEN
@export var system_color: Color = Color.PINK


var station_powered: bool = false
var station_color: Color = Color.RED

func set_station_color(new_color: Color) -> void:
	station_color = new_color
	station_color_change.emit(new_color)

func set_station_power(powered: bool) -> void:
	station_powered = powered
	station_power_change.emit(powered)
