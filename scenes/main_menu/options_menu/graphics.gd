extends VBoxContainer

@onready var render_scale_slider: HSlider = %RenderScaleSlider

func _on_render_scale_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value
