class_name StationDoor
extends Interactable

@export var door_locked: bool = false
@export var auto_close_time: float = 4.0
var door_open: bool = false
@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer


func _on_interact(_interactor: Player) -> bool:
	if door_locked: return false
	if door_open:
		close_door()
	else:
		open_door()
		_start_auto_close_timer()
	return true


func _start_auto_close_timer() -> void:
	auto_close()


func auto_close() -> void:
	await get_tree().create_timer(auto_close_time).timeout
	if door_open:
		close_door()
	
func open_door() -> void:
	anim.play("door_open")
	door_open = true
		
func close_door() -> void:
	anim.play("door_close")
	door_open = false
