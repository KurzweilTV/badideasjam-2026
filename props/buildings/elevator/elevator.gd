extends AnimatableBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $Trigger/CollisionShape3D


func _on_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		print("Elevator sees player")
		animation_player.play("ascend")
		collision_shape_3d.disabled = true
		
