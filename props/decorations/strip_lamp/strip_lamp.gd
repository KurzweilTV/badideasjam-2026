extends Node3D

@onready var light_tube: MeshInstance3D = $blockbench_export/light_tube
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

var mat: StandardMaterial3D

func _ready() -> void:
	mat = light_tube.get_active_material(0).duplicate()
	mat.emission_enabled = true
	light_tube.set_surface_override_material(0, mat)

	StationStatus.station_color_change.connect(_set_light_color)
	_set_light_color(StationStatus.station_color)

func _set_light_color(new_color: Color) -> void:
	mat.emission = new_color
	omni_light_3d.light_color = new_color
