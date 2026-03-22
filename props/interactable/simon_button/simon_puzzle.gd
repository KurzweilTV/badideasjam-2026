extends Node3D

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
var accepting_input: bool = false
var playing_sequence: bool = false
var game_active: bool = false
var infinite_mode: bool = false

func _ready() -> void:
	reset_button.reset_game.connect(_on_reset_pressed)
	all_buttons = [button_1, button_2, button_3, button_4]
	set_score_display(0)
	set_highscore_display(0)

	if demo_mode:
		initialize_demo_mode()
		return

func initialize_demo_mode() -> void:
	current_score = 0

	while demo_mode:
		await get_tree().create_timer(step_delay).timeout
		var current_button: SimonButton = all_buttons.pick_random()
		current_button.activate_button()
		await get_tree().create_timer(step_delay).timeout
		current_score += 1
		set_highscore_display(current_score)

func set_highscore_display(score: int) -> void:
	if score > high_score:
		high_score = score
		%HighScoreParticles.emitting = true
		
	high_score_display.text = str(high_score)

func set_score_display(score: int) -> void:
	score_display.text = str(score)

func start_game() -> void:
	game_active = true
	current_score = 0
	current_input_index = 0
	current_round_length = 1
	set_score_display(current_score)
	set_highscore_display(high_score)
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
	set_highscore_display(current_score)

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
	set_highscore_display(current_score)
	current_score = 0
	set_score_display(current_score)
	button_1.blink_red()
	button_2.blink_red()
	button_3.blink_red()
	button_4.blink_red()
	await get_tree().create_timer(1.0).timeout
	if not infinite_mode: start_game()

func on_player_won() -> void:
	for i in 3:
		for button in all_buttons:
			button.activate_button()
			await get_tree().create_timer(0.1).timeout

	StationStatus.open_elevator_door.emit()
	await get_tree().create_timer(0.6).timeout
	enable_infinite_mode()
	StationStatus.dialog.emit("The elevator is open.. but maybe I have time to run this sequence some more.", 1, StationStatus.player_color, false)
	
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
	game_active = false
	accepting_input = false
	playing_sequence = false
	current_score = 0
	current_input_index = 0
	current_round_length = 1
	set_score_display(current_score)
	start_game()
