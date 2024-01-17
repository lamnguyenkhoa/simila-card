extends Camera2D

var center_viewport: Vector2

func _ready() -> void:
	GameManager.main_camera = self
	center_viewport = get_viewport().get_visible_rect().size / 2

func _process(_delta):
	if not GameManager.camera_sway_enabled:
		position = Vector2.ZERO
	else:
		var mouse_pos = get_viewport().get_mouse_position()
		var camera_offset = (mouse_pos - center_viewport) / 30
		position = camera_offset