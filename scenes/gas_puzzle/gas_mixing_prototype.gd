extends Control

signal puzzle_complete

@onready var nitrogen_button: Button = %NitrogenButton
@onready var oxygen_button: Button = %OxygenButton
@onready var nitrogen_progress: ProgressBar = %NitrogenProgress
@onready var oxygen_progress: ProgressBar = %OxygenProgress
@onready var pressurize_button: Button = %PressureizeButton
@onready var error: AudioStreamPlayer = $Error
@onready var nitrogen_light: ColorRect = %NitrogenLight
@onready var oxygen_light: ColorRect = %OxygenLight
@onready var gas_fill: AudioStreamPlayer = $GasFill

@export var fill_rate: float = 35.0
@export var drain_rate: float = 5.0
@export var nitrogen_target: float = 78.0
@export var oxygen_target: float = 22.0
@export var tolerance: float = 6.0

var filling_nitrogen: bool = false
var filling_oxygen: bool = false
var complete: bool = false
var nitrogen_optimal: bool = false
var oxygen_optimal: bool = false

func _ready() -> void:
	nitrogen_progress.min_value = 0.0
	nitrogen_progress.max_value = 100.0
	oxygen_progress.min_value = 0.0
	oxygen_progress.max_value = 100.0

	nitrogen_button.button_down.connect(func() -> void: filling_nitrogen = true)
	nitrogen_button.button_up.connect(func() -> void: filling_nitrogen = false)

	oxygen_button.button_down.connect(func() -> void: filling_oxygen = true)
	oxygen_button.button_up.connect(func() -> void: filling_oxygen = false)

	pressurize_button.pressed.connect(_on_pressurize_pressed)

func _process(delta: float) -> void:

	if filling_nitrogen:
		nitrogen_progress.value += fill_rate * delta
	else:
		if nitrogen_optimal: nitrogen_progress.value += 1 * delta #slows down the drain when in the right window
		nitrogen_progress.value -= drain_rate * delta

	if filling_oxygen:
		oxygen_progress.value += fill_rate * delta
	else:
		if oxygen_optimal: oxygen_progress.value += 1 * delta #slows down the drain when in the right window
		oxygen_progress.value -= drain_rate * delta

	nitrogen_progress.value = clampf(nitrogen_progress.value, 0.0, 100.0)
	oxygen_progress.value = clampf(oxygen_progress.value, 0.0, 100.0)

	# play/stop gas sound
	if filling_nitrogen or filling_oxygen:
		if not gas_fill.playing:
			gas_fill.pitch_scale = randf_range(0.6, 0.8)
			gas_fill.play()
	else:
		if gas_fill.playing:
			gas_fill.stop()

	if abs(nitrogen_progress.value - nitrogen_target) <= tolerance:
		nitrogen_optimal = true
		nitrogen_light.color = Color.html("0b6400")
	else:
		nitrogen_optimal = false
		nitrogen_light.color = Color.DARK_RED

	if abs(oxygen_progress.value - oxygen_target) <= tolerance:
		oxygen_optimal = true
		oxygen_light.color = Color.html("0b6400")
	else:
		oxygen_optimal = false
		oxygen_light.color = Color.DARK_RED

func _on_pressurize_pressed() -> void:
	if nitrogen_optimal and oxygen_optimal:
		print("Success")
		complete = true
		StationStatus.station_oxygen_on.emit()
		StationStatus.set_station_oxygenated()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		puzzle_complete.emit()
		queue_free()
	else:
		print("Failed")
		error.play()
		nitrogen_progress.value -= 10
		oxygen_progress.value -= 10
