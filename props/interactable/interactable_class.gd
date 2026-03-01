class_name Interactable
extends StaticBody3D

@export var enabled: bool = true
@export var cooldown_time: float = 2.0
@export var interact_hint: String = "Click to Use"

var in_cooldown: bool = false

func can_interact_with() -> bool:
	return enabled and !in_cooldown

func interact(interactor: Player = null) -> bool:
	if !can_interact_with():
		return false
	var ok: bool = _on_interact(interactor)
	if ok:
		_start_cooldown()
	return ok

func _on_interact(_interactor: Player) -> bool:
	return false

func _start_cooldown() -> void:
	if cooldown_time <= 0.0: return
	in_cooldown = true
	await get_tree().create_timer(cooldown_time).timeout
	in_cooldown = false
