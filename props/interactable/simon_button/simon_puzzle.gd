extends Node3D

enum GameState {
	IDLE,
	PLAYING_SEQUENCE,
	ACCEPTING_INPUT,
	WINNING,
	LOSING
}

@export var demo_mode: bool = false
@export var puzzle_length: int = 5
@export var step_delay: float = 0.5

@onready var button_1: SimonButton = $SimonButton1
@onready var button_2: SimonButton = $SimonButton2
@onready var button_3: SimonButton = $SimonButton3
@onready var button_4: SimonButton = $SimonButton4
@onready var score_display: Label3D = $ScoreDisplay
@onready var high_score_display: Label3D = $HighScoreDisplay
@onready var reset_button: StaticBody3D = $ResetButton

var all_buttons: Array[SimonButton] = []
var current_puzzle: Array[int] = []
var current_score: int = 0
var high_score: int = 0
var current_input_index: int = 0
var current_round_length: int = 1
var game_active: bool = false
var infinite_mode: bool = false
var state: GameState = GameState.IDLE
var run_token: int = 0

func _ready() -> void:
	reset_button.reset_game.connect(_on_reset_pressed)
	all_buttons = [button_1, button_2, button_3, button_4]
	set_score_display(0)
	set_highscore_display(0)
	set_buttons_enabled(false)

	if demo_mode:
		initialize_demo_mode()

func initialize_demo_mode() -> void:
	current_score = 0

	while demo_mode:
		await get_tree().create_timer(step_delay).timeout
		if not demo_mode:
			return

		var current_button: SimonButton = all_buttons.pick_random()
		current_button.activate_button()

		await get_tree().create_timer(step_delay).timeout
		if not demo_mode:
			return

		current_score += 1
		set_highscore_display(current_score)

func set_highscore_display(score: int) -> void:
	if score > high_score:
		high_score = score
		%HighScoreParticles.emitting = true

	high_score_display.text = str(high_score)

func set_score_display(score: int) -> void:
	score_display.text = str(score)

func set_buttons_enabled(enabled: bool) -> void:
	for button in all_buttons:
		button.set_collision(enabled)

func is_accepting_input() -> bool:
	return game_active and state == GameState.ACCEPTING_INPUT

func start_game() -> void:
	run_token += 1
	var token: int = run_token

	game_active = true
	state = GameState.IDLE
	current_score = 0
	current_input_index = 0
	current_round_length = 1

	set_score_display(current_score)
	set_highscore_display(high_score)
	set_buttons_enabled(false)

	generate_new_puzzle()
	await play_current_sequence(token)

func generate_new_puzzle() -> void:
	current_puzzle.clear()

	for i in range(puzzle_length):
		current_puzzle.append(randi_range(0, all_buttons.size() - 1))

func play_current_sequence(token: int) -> void:
	if token != run_token or not game_active:
		return

	state = GameState.PLAYING_SEQUENCE
	set_buttons_enabled(false)
	current_input_index = 0

	await get_tree().create_timer(1.0).timeout
	if token != run_token or not game_active:
		return

	for i in range(current_round_length):
		if token != run_token or not game_active:
			return

		var button_index: int = current_puzzle[i]
		all_buttons[button_index].activate_button()

		await get_tree().create_timer(step_delay).timeout
		if token != run_token or not game_active:
			return

	if token != run_token or not game_active:
		return

	state = GameState.ACCEPTING_INPUT
	set_buttons_enabled(true)

func handle_player_input(button_index: int) -> void:
	if demo_mode:
		return

	if not is_accepting_input():
		return

	if button_index < 0 or button_index >= all_buttons.size():
		return

	state = GameState.IDLE
	set_buttons_enabled(false)

	all_buttons[button_index].activate_button()

	if button_index != current_puzzle[current_input_index]:
		handle_loss()
		return

	current_input_index += 1

	if current_input_index < current_round_length:
		state = GameState.ACCEPTING_INPUT
		set_buttons_enabled(true)
		return

	current_score = current_round_length
	set_score_display(current_score)
	set_highscore_display(current_score)

	if current_round_length >= puzzle_length:
		game_active = false
		state = GameState.WINNING
		set_buttons_enabled(false)
		on_player_won()
		return

	current_round_length += 1
	continue_to_next_round()

func continue_to_next_round() -> void:
	run_token += 1
	var token: int = run_token
	_continue_to_next_round(token)

func _continue_to_next_round(token: int) -> void:
	await get_tree().create_timer(step_delay).timeout
	if token != run_token or not game_active:
		return

	await play_current_sequence(token)

func handle_loss() -> void:
	run_token += 1
	var token: int = run_token

	game_active = false
	state = GameState.LOSING
	set_buttons_enabled(false)
	set_highscore_display(current_score)

	current_score = 0
	set_score_display(current_score)

	button_1.blink_red()
	button_2.blink_red()
	button_3.blink_red()
	button_4.blink_red()

	_finish_loss(token)

func _finish_loss(token: int) -> void:
	await get_tree().create_timer(1.0).timeout
	if token != run_token:
		return

	if not infinite_mode:
		start_game()
	else:
		state = GameState.IDLE

func on_player_won() -> void:
	run_token += 1
	var token: int = run_token

	set_buttons_enabled(false)

	for i in range(3):
		for button in all_buttons:
			if token != run_token:
				return

			button.activate_button()
			await get_tree().create_timer(0.1).timeout
			if token != run_token:
				return

	StationStatus.open_elevator_door.emit()

	await get_tree().create_timer(0.6).timeout
	if token != run_token:
		return

	enable_infinite_mode()
	#StationStatus.dialog.emit("The elevator is open.. but maybe I have time to run this sequence some more.", 1, StationStatus.system_color, false)

func enable_infinite_mode() -> void:
	infinite_mode = true
	puzzle_length = 1000
	var infinite_ui = [%ScoreTitle, %ScoreDisplay, %HighScoreTitle, %HighScoreDisplay, %HighScoreParticles, %ResetButton]

	for element in infinite_ui:
		element.show()

func _on_activation_area_body_entered(body: Node3D) -> void:
	if body is Player and not game_active and not infinite_mode:
		start_game()

func _on_reset_pressed() -> void:
	run_token += 1
	game_active = false
	state = GameState.IDLE
	set_buttons_enabled(false)
	current_score = 0
	current_input_index = 0
	current_round_length = 1
	set_score_display(current_score)
	start_game()
