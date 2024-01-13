extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _on_start_button_pressed() -> void:
	anim_player.play("open_level_select")


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
