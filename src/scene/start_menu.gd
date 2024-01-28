extends Control

@export var construction_img: Texture2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var level_button_container = $LevelSelect/GridContainer

var opened_level_select = false

func _ready() -> void:
	for i in range(level_button_container.get_child_count()):
		var button = level_button_container.get_child(i) as Button
		button.pressed.connect(_play_button_click_sfx)
		button.mouse_entered.connect(_play_button_hover_sfx)

		# Add in-construction icon to levels in construction and disabled it
		if i >= len(GameManager.level_list):
			button.disabled = true
			button.text = ""
			button.tooltip_text = "In construction"
			button.icon = construction_img
			button.expand_icon = true
		else:
			button.disabled = false
			button.pressed.connect(func ():  get_tree().change_scene_to_packed(GameManager.level_list[i]))
			button.text = str(i + 1)

		# Change the text color for played level
		if i in GameManager.cleared_levels:
			button.add_theme_color_override("font_color", "b8b8ff")

func _on_start_button_pressed() -> void:
	_play_button_click_sfx()
	if opened_level_select:
		return
	anim_player.play("open_level_select")
	opened_level_select = true

func _on_quit_button_pressed() -> void:
	_play_button_click_sfx()
	get_tree().quit()

func _play_button_hover_sfx() -> void:
	SoundManager.play_button_hover_sfx()

func _play_button_click_sfx() -> void:
	SoundManager.play_button_click_sfx()


# Button to choose levels
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.level_list[0])

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.level_list[1])
