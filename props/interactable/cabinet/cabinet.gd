extends Interactable

@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer
var doors_open: bool = false

func _on_interact(_interactor: Player) -> bool:
	if not doors_open:
		anim.play("open_doors")
	else: 
		anim.play("close_doors")
	doors_open= !doors_open
	return true
