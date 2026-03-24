extends Node3D

@export_category("Debug Helpers")
@export var station_starts_powered: bool = false
@export var station_starts_oxygenated: bool = false
@onready var ambient_sound: AudioStreamPlayer = $AmbientSound

func _ready() -> void:
	StationStatus.elevator_arrived.connect(_on_elevator_stop)
	SceneManager.game_mode = true
	if station_starts_powered:
		StationStatus.set_station_power(true)
	if station_starts_oxygenated:
		StationStatus.station_oxygen_on.emit()
		StationStatus.set_station_oxygenated()

func _on_elevator_stop() -> void:
	print("Stopping Ambient Sound")
	ambient_sound.stop()
