extends Node3D

@export var demo_mode: bool = false
@export var puzzle_length: int = 5
@export var step_delay: float = 0.5

@onready var button_1: SimonButton = $SimonButton1
@onready var button_2: SimonButton = $SimonButton2
@onready var button_3: SimonButton = $SimonButton3
@onready var button_4: SimonButton = $SimonButton4
@onready var high_score_display: Label3D = $HighScoreDisplay

var all_buttons: Array[SimonButton] = []
var current_puzzle: Array[int] = []
var current_score: int = 0
var current_input_index: int = 0
var current_round_length: int = 1
var accepting_input: bool = false
var playing_sequence: bool = false
var game_active: bool = false

func _ready() -> void:
	all_buttons = [button_1, button_2, button_3, button_4]
	set_score_display(0)

	if demo_mode:
		initialize_demo_mode()
		return

	start_game()

func initialize_demo_mode() -> void:
	current_score = 0

	while demo_mode:
		await get_tree().create_timer(step_delay).timeout
		var current_button: SimonButton = all_buttons.pick_random()
		current_button.activate_button()
		await get_tree().create_timer(step_delay).timeout
		current_score += 1
		set_score_display(current_score)

func set_score_display(score: int) -> void:
	high_score_display.text = str(score)

func start_game() -> void:
	game_active = true
	current_score = 0
	current_input_index = 0
	current_round_length = 1
	set_score_display(current_score)
	generate_new_puzzle()
	await play_current_sequence()

func generate_new_puzzle() -> void:
	current_puzzle.clear()

	for i in puzzle_length:
		current_puzzle.append(randi_range(0, all_buttons.size() - 1))

func play_current_sequence() -> void:
	await get_tree().create_timer(1.0).timeout
	accepting_input = false
	playing_sequence = true
	current_input_index = 0

	for i in current_round_length:
		var button_index: int = current_puzzle[i]
		all_buttons[button_index].activate_button()
		await get_tree().create_timer(step_delay).timeout

	playing_sequence = false
	accepting_input = true

func handle_player_input(button_index: int) -> void:
	if not game_active:
		return

	if demo_mode:
		return

	if playing_sequence:
		return

	if not accepting_input:
		return

	if button_index < 0 or button_index >= all_buttons.size():
		return

	all_buttons[button_index].activate_button()

	if button_index != current_puzzle[current_input_index]:
		handle_loss()
		return

	current_input_index += 1

	if current_input_index < current_round_length:
		return

	current_score = current_round_length
	set_score_display(current_score)

	if current_round_length >= puzzle_length:
		game_active = false
		accepting_input = false
		on_player_won()
		return

	current_round_length += 1
	await get_tree().create_timer(step_delay).timeout
	await play_current_sequence()

func handle_loss() -> void:
	game_active = false
	accepting_input = false
	current_score = 0
	set_score_display(current_score)
	button_1.blink_red()
	button_2.blink_red()
	button_3.blink_red()
	button_4.blink_red()
	await get_tree().create_timer(1.0).timeout
	start_game()

func on_player_won() -> void:
	for i in 3:
		for button in all_buttons:
			button.activate_button()
			await get_tree().create_timer(0.1).timeout

	StationStatus.open_elevator_door.emit()
