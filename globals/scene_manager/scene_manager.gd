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
	await get_tree().process_frame

	ResourceLoader.load_threaded_request(scene)

	while ResourceLoader.load_threaded_get_status(scene) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

	var packed: PackedScene = ResourceLoader.load_threaded_get(scene)
	get_tree().change_scene_to_packed(packed)

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
