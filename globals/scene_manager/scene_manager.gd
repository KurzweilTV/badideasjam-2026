extends CanvasLayer

signal fade_complete
signal show_terrain

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var loading_label: Label = %LoadingLabel

var game_mode: bool = false

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

## Make the mouse capture while we're playing the game
func set_game_mode(mode: bool) -> void:
	game_mode = mode

func fade_to_black() -> void:
	anim.play("dissolve")
	await anim.animation_finished
	fade_complete.emit()
	
func fade_from_black() -> void:
	anim.play_backwards("dissolve")
	await anim.animation_finished
	fade_complete.emit()
