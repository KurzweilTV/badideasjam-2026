class_name Dialog
extends PanelContainer

@onready var dialog_box: RichTextLabel = $DialogBox
@onready var typing_click: AudioStreamPlayer = $TypingClick

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

func _new_message(message: String, delay: float, border: Color) -> void:
	await get_tree().create_timer(delay).timeout
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
	StationStatus.dialog.emit("What... Where am I?", 2, StationStatus.player_color)
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("I'm in a pressure suit???", 1, StationStatus.player_color)
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("The [color=green]oxygen[/color] reading is low...", 1, StationStatus.player_color)
	await StationStatus.dialog_complete
	_opening_tutorial()

func _opening_tutorial() -> void:
	StationStatus.dialog.emit("Use [color=bright_pink]WASD[/color] to move", 1, StationStatus.system_color)
	await StationStatus.dialog_complete
	StationStatus.dialog.emit("Press [color=bright_pink]F[/color] to turn on your flashlight", 1, StationStatus.system_color)
