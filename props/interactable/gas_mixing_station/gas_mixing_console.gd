extends Interactable

const GAS_GAME_UI = preload("uid://bagm2vkdk8g04")
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_interact(_interactor: Player) -> bool:
	var gas_game_scene = GAS_GAME_UI.instantiate()
	add_child(gas_game_scene)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	collision_shape_3d.disabled = true
	
	return true
