extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var level_button_container = $LevelSelect/GridContainer

func _ready() -> void:
	for i in range(level_button_container.get_child_count()):
		var button = level_button_container.get_child(i) as Button
		if i <= GameManager.highest_level_id:
			button.disabled = false
		else:
			button.disabled = true

func _on_start_button_pressed() -> void:
	anim_player.play("open_level_select")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.level_list[0])

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.level_list[1])
