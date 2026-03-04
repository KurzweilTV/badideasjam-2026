# Global.gd (autoload)
extends Node
signal station_power_change(powered: bool)
signal station_color_change(new_color: Color)

var station_powered: bool = false
var station_color: Color = Color.WHITE

func set_station_color(new_color: Color) -> void:
	station_color = new_color
	station_color_change.emit(new_color)

func set_station_power(powered: bool) -> void:
	station_powered = powered
	station_power_change.emit(powered)
