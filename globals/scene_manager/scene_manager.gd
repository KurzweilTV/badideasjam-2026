extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
	
func change_scene(scene: String) -> void:
	anim.play("dissolve")
	await anim.animation_finished
	var scene_to_load: PackedScene = load(scene)
	get_tree().change_scene_to_packed(scene_to_load)
	await get_tree().process_frame
	anim.play_backwards("dissolve")
