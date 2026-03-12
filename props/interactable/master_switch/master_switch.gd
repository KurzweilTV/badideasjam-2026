extends Interactable

@export var is_on: bool = false
@onready var anim: AnimationPlayer = $blockbench_export/AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_interact(_interactor: Player) -> bool:
	print("MASTER SWITCH TRIGGERED")
	anim.play("turn_on")
	collision_shape_3d.disabled = true #only allow this to work once.
	trigger_change()
	return true

func trigger_change() -> void:
	await anim.animation_finished	
	$ClickSound.play()
	StationStatus.set_station_power(true)
	StationStatus.set_station_color(Color.WHITE)
	StationStatus.dialog.emit("Yes! The [color=yellow]power[/color] and the [color=green]oxygen[/color] are coming online!", 2, StationStatus.player_color, false, "dialog_09.mp3")
