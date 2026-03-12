class_name DialogTrigger
extends Area3D

@export_category("Message Parameters")
@export var single_trigger: bool = true
@export_multiline("This is a [color=blue]test[/color] message.") var message: String
@export var delay: float = 1.0
@export var border_color: Color = Color.PALE_GREEN
@export var trigger_area: Shape3D
@export var voice_over_file: String

@onready var collision_area: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	if trigger_area != null:
		collision_area.shape = trigger_area

func _on_body_entered(body: Node3D) -> void:
	if not single_trigger: return
	if body is Player:
		StationStatus.dialog.emit(message, delay, border_color, false, voice_over_file)
		single_trigger = false
