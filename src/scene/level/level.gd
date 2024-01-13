extends Control
class_name Level

@export var level_id: int
@export_multiline var level_description: String

@export var allow_number_compare = true
@export var allow_color_compare = true
@export var allow_tag_compare = true

@onready var table_card_holder = $TableCardHolder
@onready var hand_card_holder = $HandCardHolder

func _ready() -> void:
	GameManager.update_current_level(self)
	GameManager.card_moved.connect(check_if_win_level)

func move_card_hand_to_table(card: Card, card_slot: CardSlot):
	if check_eligible(card, card_slot):
		card.get_parent().remove_child(card)
		card_slot.add_child(card)
		card.placed = true
		card.position = (card_slot.size - card.size) / 2 # center of card slot
		card.selected = false
		GameManager.selected_card = null
		GameManager.emit_signal("card_moved", card)
	else:
		card.set_unselected()

func move_card_table_to_hand(card: Card):
	if not card.placed or not card.get_parent() is CardSlot:
		return

	card.placed = false
	card.get_parent().remove_child(card)
	hand_card_holder.add_child(card)
	GameManager.emit_signal("card_moved", card)
	GameManager.selected_card = null


func check_eligible(card: Card, card_slot: CardSlot) -> bool:
	var slot_idx = card_slot.get_index()
	var left_slot = null
	if slot_idx > 0:
		left_slot = table_card_holder.get_child(slot_idx - 1)
	var right_slot = null
	if slot_idx < table_card_holder.get_child_count() - 1:
		right_slot = table_card_holder.get_child(slot_idx + 1)

	if left_slot != null and left_slot.check_if_already_has_card():
		var left_card = left_slot.get_stored_card()
		var left_res = compare_card(left_card, card)
		if left_res == "Dissimilar!":
			card_slot.show_check_result(left_res, false, true)
			return false
		else:
			card_slot.show_check_result(left_res, true, true)

	if right_slot != null and right_slot.check_if_already_has_card():
		var right_card = right_slot.get_stored_card()
		var right_res = compare_card(right_card, card)
		if right_res == "Dissimilar!":
			card_slot.show_check_result(right_res, false, false)
			return false
		else:
			card_slot.show_check_result(right_res, true, false)

	return true

func compare_card(card_to_check: Card, placed_card: Card) -> String:
	if allow_number_compare:
		var common_numbers = intersect(card_to_check.data.card_number, placed_card.data.card_number)
		if len(common_numbers) > 0:
			return "Similar\nnumber!"
	if allow_color_compare:
		var common_colors = intersect(card_to_check.data.card_color, placed_card.data.card_color)
		if len(common_colors) > 0:
			return "Similar\ncolor!"
	if allow_tag_compare:
		var common_tags = intersect(card_to_check.data.card_tags, placed_card.data.card_tags)
		if len(common_tags) > 0:
			return "Similar\ntype!"
	return "Dissimilar!"


func intersect(array1, array2):
	var intersection = []
	for item in array1:
		if array2.has(item):
			intersection.append(item)
	return intersection

func check_if_win_level(_card: Card):
	if hand_card_holder.get_child_count() == 0:
		for child in table_card_holder.get_children():
			var card = child.get_stored_card()
			if card != null:
				card.set_locked()

		GameManager.finish_level()
