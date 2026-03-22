extends Interactable

const GAS_GAME_UI = preload("uid://bagm2vkdk8g04")
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var indicator_light: OmniLight3D = $IndicatorLight

func _on_interact(_interactor: Player) -> bool:
	var gas_game_scene = GAS_GAME_UI.instantiate()
	add_child(gas_game_scene)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	collision_shape_3d.disabled = true
	gas_game_scene.puzzle_complete.connect(play_complete_sound)
	return true

func play_complete_sound() -> void:
	%Complete.play()
	indicator_light.light_color = Color.GREEN
