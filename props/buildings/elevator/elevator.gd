extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trigger: CollisionShape3D = $Trigger/CollisionShape3D


func _on_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		if StationStatus.station_powered:
			print("Elevator sees player")
			StationStatus.close_elevator_door.emit()
			await get_tree().create_timer(1.0).timeout
			animation_player.play("ascend")
			StationStatus.elevator_moving.emit()
			trigger.disabled = true
		else:
			print("Elevator isn't Powered")
		
