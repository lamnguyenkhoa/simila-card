extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var level1: PackedScene

func _on_start_button_pressed() -> void:
	anim_player.play("open_level_select")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(level1)

