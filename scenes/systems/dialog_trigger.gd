class_name DialogTrigger
extends Area3D

@export_category("Message Parameters")
@export var single_trigger: bool = true
@export var tutorial_force: bool = false
@export_multiline("This is a [color=blue]test[/color] message.") var message: String
@export var delay: float = 1.0
@export var border_color: Color = Color.PALE_GREEN
@export var trigger_area: Shape3D
@export var voice_over_file: String
@export var look_target: Node3D

@onready var collision_area: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	if tutorial_force:
		StationStatus.got_oxygen_mask.connect(func(): single_trigger = false)
	if trigger_area != null:
		collision_area.shape = trigger_area

func _on_body_entered(body: Node3D) -> void:
	print_orphan_nodes()
	if not single_trigger: return
	if body is Player and not body.has_oxygen_mask:
		if look_target:
			body.look_at_node(look_target)
			StationStatus.dialog.emit(message, delay, border_color, false, voice_over_file)
			return
	if body is Player:
		StationStatus.dialog.emit(message, delay, border_color, false, voice_over_file)
		single_trigger = false
