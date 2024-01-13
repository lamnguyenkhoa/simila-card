extends TextureRect
class_name CardSlot

@onready var left_label: Label = $LeftLabel
@onready var right_label: Label = $RightLabel
@onready var hide_label_timer: Timer = $HideLabelTimer

var highlighted = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		if highlighted and GameManager.selected_card != null and not check_if_already_has_card():
			GameManager.current_level.move_card_hand_to_table(GameManager.selected_card, self)

func check_if_already_has_card() -> bool:
	for child in get_children():
		if child is Card:
			return true
	return false

func get_stored_card() -> Card:
	for child in get_children():
		if child is Card:
			return child
	return null

func show_check_result(text: String, is_correct: bool, is_left: bool):
	var label: Label = null
	if is_left:
		label = left_label
	else:
		label = right_label
	label.text = text
	label.self_modulate = Color(1, 1, 1, 0)
	if is_correct:
		label.self_modulate = EnumAutoload.CORRECT_COLOR
	else:
		label.self_modulate = EnumAutoload.INCORRECT_COLOR
	hide_label_timer.start()

func _on_mouse_entered() -> void:
	highlighted = true

func _on_mouse_exited() -> void:
	highlighted = false

func _on_hide_label_timer_timeout() -> void:
	left_label.self_modulate = Color(1, 1, 1, 0)
	right_label.self_modulate = Color(1, 1, 1, 0)
