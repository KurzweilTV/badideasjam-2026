extends VBoxContainer

@onready var main_slider: HSlider = %MainSlider
@onready var sound_slider: HSlider = %SoundSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var hover: AudioStreamPlayer = %Hover

var main_bus :int = AudioServer.get_bus_index("Master")
var sounds_bus :int = AudioServer.get_bus_index("Sounds")
var music_bus :int = AudioServer.get_bus_index("Music")

func _ready() -> void: # makes the sliders match the bus settings
	main_slider.value = db_to_linear(AudioServer.get_bus_volume_db(main_bus))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sounds_bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))

func _on_main_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(main_bus, linear_to_db(value))
	hover.play()

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sounds_bus, linear_to_db(value))
	hover.play()
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	hover.play()
