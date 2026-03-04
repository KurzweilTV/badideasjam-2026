extends Interactable

@onready var closed_1: CollisionShape3D = $Closed1
@onready var open_1: CollisionShape3D = $Open1
@onready var open_2: CollisionShape3D = $Open2
@onready var open_3: CollisionShape3D = $Open3


@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer
var doors_open: bool = false

func _on_interact(_interactor: Player) -> bool:
	if not doors_open:
		anim.play("open_doors")
		closed_1.disabled = true
		open_1.disabled = false
		open_2.disabled = false
		open_3.disabled = false
	else: 
		anim.play("close_doors")
		closed_1.disabled = false
		open_1.disabled = true
		open_2.disabled = true
		open_3.disabled = true
	doors_open= !doors_open
	return true
