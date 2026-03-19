extends Control

@onready var nitrogen_button: Button = %NitrogenButton
@onready var oxygen_button: Button = %OxygenButton
@onready var nitrogen_progress: ProgressBar = %NitrogenProgress
@onready var oxygen_progress: ProgressBar = %OxygenProgress
@onready var pressurize_button: Button = %PressureizeButton

@export var fill_rate: float = 35.0
@export var drain_rate: float = 4.0
@export var nitrogen_target: float = 78.0
@export var oxygen_target: float = 22.0
@export var tolerance: float = 6.0

var holding_nitrogen: bool = false
var holding_oxygen: bool = false
var complete: bool = false

func _ready() -> void:
	nitrogen_progress.min_value = 0.0
	nitrogen_progress.max_value = 100.0
	oxygen_progress.min_value = 0.0
	oxygen_progress.max_value = 100.0

	nitrogen_button.button_down.connect(func() -> void: holding_nitrogen = true)
	nitrogen_button.button_up.connect(func() -> void: holding_nitrogen = false)

	oxygen_button.button_down.connect(func() -> void: holding_oxygen = true)
	oxygen_button.button_up.connect(func() -> void: holding_oxygen = false)

	pressurize_button.pressed.connect(_on_pressurize_pressed)

func _process(delta: float) -> void:
	if complete: return
	if holding_nitrogen:
		nitrogen_progress.value += fill_rate * delta
	else:
		nitrogen_progress.value -= drain_rate * delta

	if holding_oxygen:
		oxygen_progress.value += fill_rate * delta
	else:
		oxygen_progress.value -= drain_rate * delta

	nitrogen_progress.value = clampf(nitrogen_progress.value, 0.0, 100.0)
	oxygen_progress.value = clampf(oxygen_progress.value, 0.0, 100.0)
	
	if nitrogen_progress.value < 85 and nitrogen_progress.value > 75:
		nitrogen_progress.modulate = Color.GREEN
	else:
		nitrogen_progress.modulate = Color.RED

	if oxygen_progress.value < 27 and oxygen_progress.value > 17:
		oxygen_progress.modulate = Color.GREEN
	else:
		oxygen_progress.modulate = Color.RED

func _on_pressurize_pressed() -> void:
	var nitrogen_ok: bool = absf(nitrogen_progress.value - nitrogen_target) <= tolerance
	var oxygen_ok: bool = absf(oxygen_progress.value - oxygen_target) <= tolerance

	if nitrogen_ok and oxygen_ok:
		print("Success")
		complete = true
	else:
		print("Failed")
