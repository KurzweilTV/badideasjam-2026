extends Marker3D

@onready var crowbar: Node3D = $Crowbar

func _set_crowbar(held: bool) -> void:
	crowbar.visible = held
