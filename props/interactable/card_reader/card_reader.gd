extends Interactable

const MATERIAL_0 = preload("uid://tbqtovba2i70")
@onready var mesh: MeshInstance3D = $beveled_cuboid
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var positive: AudioStreamPlayer3D = $Positive
@onready var negative: AudioStreamPlayer3D = $Negative

func _on_interact(interactor: Player) -> bool:
	if interactor.access_level >= 1:
		animate_cardreader(Color.GREEN)
		positive.play()
		StationStatus.id_card_used.emit() # unlocks the door
		return true
	else:
		animate_cardreader(Color.RED)
		negative.play()
		return true

func animate_cardreader(new_color: Color) -> void:
	set_color(new_color)
	await get_tree().create_timer(1).timeout
	set_color(Color.WHITE)

func set_color(new_color: Color) -> void: ## Sets the color change on the ID panel
	omni_light_3d.light_color = new_color

	var mat := MATERIAL_0.duplicate()
	mat.emission = new_color

	mesh.set_surface_override_material(0, mat)
