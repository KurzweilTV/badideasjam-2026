extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var loading_label: Label = %LoadingLabel

func change_scene(scene: String) -> void:
	anim.play("dissolve")
	await anim.animation_finished
	loading_label.show()
	#await get_tree().create_timer(2.0).timeout #DEBUG: simulate Loading time
	var scene_to_load: PackedScene = load(scene)
	get_tree().change_scene_to_packed(scene_to_load)
	await get_tree().process_frame
	loading_label.hide()
	anim.play_backwards("dissolve")
