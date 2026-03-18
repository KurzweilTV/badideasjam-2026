extends VBoxContainer

@onready var main_slider: HSlider = %MainSlider
@onready var sound_slider: HSlider = %SoundSlider
@onready var ambient_slider: HSlider = %MusicSlider
@onready var voice_slider: HSlider = %VoiceSlider

@onready var hover: AudioStreamPlayer = %Hover

var main_bus :int = AudioServer.get_bus_index("Master")
var sounds_bus :int = AudioServer.get_bus_index("Sounds")
var ambient_bus :int = AudioServer.get_bus_index("Ambient")
var voice_bus :int = AudioServer.get_bus_index("VoiceOver")

func _ready() -> void: # makes the sliders match the bus settings
	main_slider.value = db_to_linear(AudioServer.get_bus_volume_db(main_bus))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sounds_bus))
	ambient_slider.value = db_to_linear(AudioServer.get_bus_volume_db(ambient_bus))
	voice_slider.value = db_to_linear(AudioServer.get_bus_volume_db(voice_bus))
	
func _on_main_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(main_bus, linear_to_db(value))
	hover.play()

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sounds_bus, linear_to_db(value))
	hover.play()
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(ambient_bus, linear_to_db(value))
	hover.play()

func _on_voice_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(voice_bus, linear_to_db(value))
	hover.play()
