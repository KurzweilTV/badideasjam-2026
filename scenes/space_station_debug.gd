extends Node3D

@export_category("Debug Helpers")
@export var station_starts_powered: bool = false

func _ready() -> void:
	SceneManager.game_mode = true
	if station_starts_powered:
		StationStatus.set_station_power(true)
