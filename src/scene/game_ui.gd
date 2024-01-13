@tool
extends Control
class_name GameUI

@onready var level_label: Label = $LevelLabel
@onready var description_label: Label = $DescriptionLabel
@onready var setting_panel: Panel = $SettingPanel

func _ready() -> void:
	if get_parent() is Level:
		var level = get_parent() as Level
		level_label.text = "Level " + str(level.level_id)
		description_label.text = level.level_description

func _on_setting_button_pressed() -> void:
	setting_panel.visible = !setting_panel.visible
