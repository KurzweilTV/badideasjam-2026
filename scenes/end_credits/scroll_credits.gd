extends RichTextLabel

@export var speed := 60.0

func _process(delta):
	position.y -= speed * delta
