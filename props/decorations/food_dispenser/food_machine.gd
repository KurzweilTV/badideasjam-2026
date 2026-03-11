extends StaticBody3D

@onready var light_1: OmniLight3D = $Light1
@onready var mesh: MeshInstance3D = $blockbench_export/mesh
const MATERIAL_0 = preload("uid://db8o17k5lxyl")

func _ready() -> void:
	StationStatus.station_power_change.connect(_enable_lights)

func _enable_lights(status: bool) -> void:
	light_1.visible = status
	
	var mat := MATERIAL_0.duplicate()
	mat.emission_enabled = status
	mesh.set_surface_override_material(0, mat)
