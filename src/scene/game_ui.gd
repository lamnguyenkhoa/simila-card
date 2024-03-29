@tool
extends Control
class_name GameUI

@onready var level_label: Label = $LevelLabel
@onready var description_label: Label = $DescriptionLabel
@onready var level_finish_panel = $LevelFinishPanel
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var next_level_button = $LevelFinishPopup/HBoxContainer/NextButton
@onready var similarity_label = $SimilarityLabel
@onready var level_finished_label: Label = $LevelFinishPopup/Title

@onready var zoom_camera: Camera2D = $SubViewportContainer/SubViewport/ZoomCamera
@onready var zoom_texture: TextureRect = $SubViewportContainer/SubViewport/CardTexture
@onready var viewport_container = $SubViewportContainer

@export var level: Level

var next_level_scene: PackedScene = null

func _ready() -> void:
	if level:
		level_label.text = "Level " + str(level.level_id + 1)
		description_label.text = level.level_description
		setup_similarity_label()
	if not Engine.is_editor_hint():
		GameManager.level_finished.connect(_on_level_finished)
		GameManager.game_ui = self

func _process(_delta):
	if Engine.is_editor_hint() or not GameManager.zoom_camera_enabled:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	zoom_camera.global_position = mouse_pos + GameManager.main_camera.position


func setup_similarity_label():
	similarity_label.text = "Allowed similarity:"
	if level.allow_color_compare:
		similarity_label.text += '\n- Color'
	if level.allow_number_compare:
		similarity_label.text += '\n- Number'
	if level.allow_symbol_compare:
		similarity_label.text += '\n- Symbol'
	if level.allow_origin_compare:
		similarity_label.text += '\n- Origin'

func show_zoom_camera(card: Card, _visible: bool):
	if not GameManager.zoom_camera_enabled:
		_visible = false
	viewport_container.visible = _visible
	if not _visible:
		return

	zoom_texture.texture = card.data.card_sprite
	if card.placed:
		zoom_texture.global_position = card.global_position + Vector2(0, -10)
		viewport_container.global_position = card.global_position + Vector2(0, 200) - GameManager.main_camera.position
	else:
		zoom_texture.global_position = card.global_position + Vector2(0, -100)
		viewport_container.global_position = card.global_position + Vector2(0, -250) - GameManager.main_camera.position

func _on_level_finished(level_id: int):
	anim_player.play("open_level_finish_panel")
	if level_id + 1 < len(GameManager.level_list):
		next_level_scene = GameManager.level_list[level_id + 1]
	else:
		next_level_button.visible  = false
		level_finished_label.text = "Level finished!\nThanks for playing~"

func _on_next_button_pressed() -> void:
	SoundManager.play_button_click_sfx()
	if next_level_scene != null:
		get_tree().change_scene_to_packed(next_level_scene)

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
	SoundManager.play_button_click_sfx()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.start_menu)
	SoundManager.play_button_click_sfx()

func _play_button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func _play_button_click_sfx():
	SoundManager.play_button_click_sfx()
