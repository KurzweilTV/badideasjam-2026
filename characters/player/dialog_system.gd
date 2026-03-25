class_name Dialog
extends PanelContainer

@onready var dialog_box: RichTextLabel = $DialogBox
@onready var typing_click: AudioStreamPlayer = $TypingClick
@onready var voice_over: AudioStreamPlayer3D = $VoiceOver

var base_typing_speed: float = 12.0
var typing_speed: float = 15.0 
var char_progress: float = 0.0
var typing: bool = false
var hide_timer: float = 0.0
var waiting_to_hide: bool = false

func _ready() -> void:
	StationStatus.dialog.connect(_new_message)
	hide()

func _process(delta: float) -> void:
	if typing and dialog_box.visible_characters < dialog_box.text.length():
		char_progress += typing_speed * delta
		#typing_click.pitch_scale = randf_range(0.6, 0.8)
		#typing_click.play()
		dialog_box.visible_characters = int(char_progress)
	elif typing:
		typing = false
		waiting_to_hide = true
		hide_timer = 3.0

	if waiting_to_hide:
		hide_timer -= delta
		if hide_timer <= 0.0:
			waiting_to_hide = false
			StationStatus.dialog_complete.emit()
			hide()

func _new_message(message: String, delay: float, border: Color, tutorial: bool = false, vo_file: String = "") -> void:
	if tutorial: 
		typing_speed = 500
	else: 
		typing_speed = base_typing_speed
		
	await get_tree().create_timer(delay).timeout
	if vo_file != "": # plays VO file, if it exists
		voice_over.stream = load("res://characters/player/voiceover/zeer/" + vo_file)
		voice_over.play()
	_set_border_color(border)
	show()
	dialog_box.text = message
	dialog_box.visible_characters = 0
	char_progress = 0.0
	typing = true
	waiting_to_hide = false
	
func _set_border_color(new_color: Color) -> void:
	var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	style.border_color = new_color
	add_theme_stylebox_override("panel", style)

func _opening_dialog() -> void:
	StationStatus.dialog.emit("What... Where am I?", 1, StationStatus.player_color, false, "whereami.wav")
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("Press [color=pink]F[/color] to turn on your flashlight", 1, StationStatus.system_color, true)
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("Why is it so hard to breathe? The [color=green]air[/color] is so stale...", 1, StationStatus.player_color, false, "hardtobreathe1.wav")
	await StationStatus.dialog_complete
	#StationStatus.dialog.emit("I'm in some sort of... pressure suit?", 1, StationStatus.player_color, false, "dialog_02.mp3")
	#await StationStatus.dialog_complete
	#StationStatus.dialog.emit("Looks like the [color=green]oxygen[/color] is low. I should find some air", 1, StationStatus.player_color, false, "dialog_03.mp3")
	#await StationStatus.dialog_complete
	StationStatus.dialog.emit("Use [color=pink]WASD[/color] to move", 1, StationStatus.system_color, true)
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("Use the [color=pink]left mouse button[/color] to interact", 1, StationStatus.system_color, true)
