extends ColorRect

@export var duration: float
@export var vision_radius: float

var shader: ShaderMaterial

func _ready() -> void:
	shader = material as ShaderMaterial

func activate() -> void:
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(tween_night_vision, shader.get_shader_parameter("lens_radius"), vision_radius, duration)
	tween.chain().tween_callback(func() -> void: shader.set_shader_parameter("on", true))

func deactivate() -> void:
	shader.set_shader_parameter("on", false)
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(tween_night_vision, shader.get_shader_parameter("lens_radius"), 1.0, duration)

func tween_night_vision(lens_radius: float) -> void:
	shader.set_shader_parameter("lens_radius", lens_radius)
