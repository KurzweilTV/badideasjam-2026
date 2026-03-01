class_name StationDoor
extends Interactable

@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer

var door_open: bool = false

func _on_interact(_interactor: Player) -> bool:
	if not door_open:
		anim.play("door_open")
		door_open = true
		return true
	else:
		anim.play("door_close")
		door_open = false
		return true
		
