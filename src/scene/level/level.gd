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
	GameManager.current_level = self

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

	card.get_parent().remove_child(card)
	card.placed = false
	hand_card_holder.add_child(card)
	GameManager.emit_signal("card_moved", card)


func check_eligible(card: Card, card_slot: CardSlot) -> bool:
	var slot_idx = card_slot.get_index()
	var left_slot = table_card_holder.get_child(slot_idx - 1)
	var right_slot = table_card_holder.get_child(slot_idx + 1)

	if left_slot.get_child_count() > 0:
		var left_card = left_slot.get_child(0)
		var left_res = compare_card(left_card, card)
		if left_res == "Wrong":
			return false
		else:
			print("Left res ", left_res)

	if right_slot.get_child_count() > 0:
		var right_card = right_slot.get_child(0)
		var right_res = compare_card(right_card, card)
		if right_res == "Wrong":
			return false
		else:
			print("Right res ", right_res)

	return true

func compare_card(card_to_check: Card, placed_card: Card) -> String:
	if allow_number_compare:
		var common_numbers = intersect(card_to_check.data.card_number, placed_card.data.card_number)
		if len(common_numbers) > 0:
			return "Similar number!"
	if allow_color_compare:
		var common_colors = intersect(card_to_check.data.card_color, placed_card.data.card_color)
		if len(common_colors) > 0:
			return "Similar color!"
	if allow_tag_compare:
		var common_tags = intersect(card_to_check.data.card_tags, placed_card.data.card_tags)
		if len(common_tags) > 0:
			return "Similar type!"
	return "Wrong"


func intersect(array1, array2):
	var intersection = []
	for item in array1:
		if array2.has(item):
			intersection.append(item)
	return intersection
