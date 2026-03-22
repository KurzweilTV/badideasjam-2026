extends Interactable

signal reset_game

const MATERIAL_1 = preload("uid://ccyrw34jqcngj")

@export var button_color: Color = Color.WHITE
@onready var mesh_instance: MeshInstance3D = $blockbench_export/buttonface/button
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer

var material: StandardMaterial3D

func _ready() -> void:
	material = MATERIAL_1.duplicate() as StandardMaterial3D
	material.albedo_color = button_color
	material.emission_enabled = false
	material.emission = button_color
	material.emission_energy_multiplier = 2
	mesh_instance.set_surface_override_material(0, material)

func _on_interact(_interactor: Player) -> bool:
	animation_player.play("press")
	%click.play()
	reset_game.emit()
	return true
