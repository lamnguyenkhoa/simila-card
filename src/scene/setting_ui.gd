extends Control
class_name SettingUI

@onready var setting_panel: Panel = $SettingPanel
@onready var bgm_slider: HSlider = $SettingPanel/BGMSlider
@onready var sfx_slider: HSlider = $SettingPanel/SFXSlider
@onready var zoom_camera_button: Button = $SettingPanel/ZoomCameraButton
@onready var camera_sway_button: Button = $SettingPanel/CameraSwayButton


func _ready() -> void:
	bgm_slider.value = SoundManager.get_music_volume() * 100
	sfx_slider.value = SoundManager.get_sound_volume() * 100
	zoom_camera_button.button_pressed = GameManager.zoom_camera_enabled
	camera_sway_button.button_pressed = not GameManager.camera_sway_enabled

func _on_setting_button_pressed() -> void:
	setting_panel.visible = !setting_panel.visible
	bgm_slider.value = SoundManager.get_music_volume() * 100
	sfx_slider.value = SoundManager.get_sound_volume() * 100
	SoundManager.play_button_click_sfx()

func _on_sfx_slider_value_changed(value:float) -> void:
	SoundManager.set_sound_volume(value / 100)

func _on_bgm_slider_value_changed(value:float) -> void:
	SoundManager.set_music_volume(value / 100)


func _on_button_mouse_entered() -> void:
	SoundManager.play_button_hover_sfx()


func _on_zoom_camera_button_toggled(button_pressed:bool) -> void:
	GameManager.zoom_camera_enabled = button_pressed


func _on_camera_sway_button_toggled(button_pressed:bool) -> void:
	GameManager.camera_sway_enabled = not button_pressed


func _on_show_card_color_button_toggled(button_pressed:bool) -> void:
	GameManager.change_setting_show_card_color(button_pressed)
