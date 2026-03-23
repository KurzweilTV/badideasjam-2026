extends RichTextLabel

@export var scroll_speed := 60.0

func _process(delta):
	position.y -= scroll_speed * delta
