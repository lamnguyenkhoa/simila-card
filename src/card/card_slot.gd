extends TextureRect
class_name CardSlot

var highlighted = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if highlighted and GameManager.selected_card != null:
			GameManager.current_level.move_card_hand_to_table(GameManager.selected_card, self)


func _on_mouse_entered() -> void:
	highlighted = true
	
func _on_mouse_exited() -> void:
	highlighted = false