extends AudioStreamPlayer3D

const ELEVATOR_ARRIVE = preload("uid://dp12xo11r5cea")
const MOUNTAIN_HUM = preload("uid://bup5cdqc8d76d")
const ELEVATOR_STOPS = preload("uid://b7aud4wh6pmu6")

func _ready() -> void:
	StationStatus.open_elevator_door.connect(_on_elevator_arrive)
	StationStatus.elevator_moving.connect(_on_elevator_moving)
	StationStatus.elevator_complete.connect(_on_elevator_complete)
	
func _on_elevator_arrive() -> void:
	self.stream = ELEVATOR_ARRIVE
	self.play()

func _on_elevator_moving() -> void:
	self.stream = MOUNTAIN_HUM
	self.play()

func _on_elevator_complete() -> void:
	StationStatus.elevator_arrived.emit()
	self.stream = ELEVATOR_STOPS
	self.volume_db = -5.0
	self.play()
