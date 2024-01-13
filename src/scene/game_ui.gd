@tool
extends Control
class_name GameUI

@onready var level_label: Label = $LevelLabel
@onready var description_label: Label = $DescriptionLabel
@onready var setting_panel: Panel = $SettingPanel
@onready var level_finish_panel = $LevelFinishPanel
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var next_level_button = $LevelFinishPopup/HBoxContainer/NextButton

var next_level_scene: PackedScene = null

func _ready() -> void:
	if get_parent() is Level:
		var level = get_parent() as Level
		level_label.text = "Level " + str(level.level_id + 1)
		description_label.text = level.level_description

	if not Engine.is_editor_hint():
		GameManager.level_finished.connect(_on_level_finished)

func _on_level_finished(level_id: int):
	anim_player.play("open_level_finish_panel")
	if level_id + 1 < len(GameManager.level_list):
		next_level_scene = GameManager.level_list[level_id + 1]
	else:
		next_level_button.visible  = false
		print("Out of level, back to menu pls")


func _on_setting_button_pressed() -> void:
	setting_panel.visible = !setting_panel.visible


func _on_next_button_pressed() -> void:
	if next_level_scene != null:
		get_tree().change_scene_to_packed(next_level_scene)


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.start_menu)


