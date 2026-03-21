class_name SimonButton
extends Interactable

const MATERIAL_1 = preload("uid://ccyrw34jqcngj")

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var simon_tone: AudioStreamPlayer3D = $simon_tone
@onready var mesh_instance: MeshInstance3D = $blockbench_export/buttonface/button
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var simon_game: Node3D = get_parent()

@export var button_index: int = 0
@export var button_color: Color = Color.WHITE
@export var tone_duration: float = 0.1
@export var pitch_modifier: float = 1.0
@export var emission_energy: float = 2.0

var material: StandardMaterial3D
var flash_id: int = 0
var tone_id: int = 0

func _ready() -> void:
	material = MATERIAL_1.duplicate() as StandardMaterial3D
	material.albedo_color = button_color
	material.emission_enabled = false
	material.emission = button_color
	material.emission_energy_multiplier = emission_energy
	omni_light_3d.light_color = button_color
	mesh_instance.set_surface_override_material(0, material)

func activate_button() -> void:
	flash_id += 1
	tone_id += 1

	var current_flash_id: int = flash_id
	var current_tone_id: int = tone_id

	if animator.is_playing():
		animator.stop()

	animator.play("press")
	set_lit(true)

	simon_tone.stop()
	simon_tone.pitch_scale = pitch_modifier
	simon_tone.play()

	_finish_flash(current_flash_id)
	_finish_tone(current_tone_id)

func _finish_flash(current_flash_id: int) -> void:
	await get_tree().create_timer(tone_duration).timeout

	if current_flash_id != flash_id:
		return

	set_lit(false)

func _finish_tone(current_tone_id: int) -> void:
	await get_tree().create_timer(tone_duration).timeout

	if current_tone_id != tone_id:
		return

	simon_tone.stop()

func set_lit(status: bool) -> void:
	material.emission_enabled = status
	omni_light_3d.visible = status

func blink_red(duration: float = 0.4) -> void:
	flash_id += 1
	var current_flash_id: int = flash_id

	var original_color: Color = material.emission
	var original_light: Color = omni_light_3d.light_color

	var error_red: Color = Color(1.0, 0.1, 0.1)

	material.emission = error_red
	material.emission_enabled = true
	omni_light_3d.light_color = error_red
	omni_light_3d.visible = true
	$error_tone.play()

	await get_tree().create_timer(duration).timeout

	if current_flash_id != flash_id:
		return

	material.emission = original_color
	material.emission_enabled = false
	omni_light_3d.light_color = original_light
	omni_light_3d.visible = false

func _on_interact(_interactor: Player) -> bool:
	activate_button()
	simon_game.handle_player_input(button_index)
	return true
