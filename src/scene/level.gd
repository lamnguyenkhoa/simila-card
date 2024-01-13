extends Control
class_name Level

@onready var table_card_holder = $TableCardHolder
@onready var hand_card_holder = $HandCardHolder

func _ready() -> void:
	GameManager.current_level = self

func move_card_hand_to_table(card: Card, card_slot: CardSlot):
	card.get_parent().remove_child(card)
	card_slot.add_child(card)
	card.placed = true
	card.position = (card_slot.size - card.size) / 2 # center of card slot
	card.selected = false
	GameManager.selected_card = null
	GameManager.emit_signal("card_moved", card)

func move_card_table_to_hand(card: Card):
	if not card.placed or not card.get_parent() is CardSlot:
		return

	card.get_parent().remove_child(card)
	hand_card_holder.add_child(card)
	GameManager.emit_signal("card_moved", card)
