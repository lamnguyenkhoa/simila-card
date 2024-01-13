@tool
extends Control
class_name Card

@export var data: CardResource
@export var locked = false

@onready var card_texture: TextureRect = $TextureRect

var texture_original_pos: Vector2
var highlighted = false
var selected = false
var placed = false

func _ready() -> void:
	if data.card_sprite:
		card_texture.texture = data.card_sprite
	if locked:
		card_texture.self_modulate = Color(0.5, 0.5, 0.5, 1)
		var card_slot = get_parent()
		if card_slot is CardSlot:
			placed = true
			position = (card_slot.size - size) / 2
			selected = false
		
	if not Engine.is_editor_hint():
		texture_original_pos = card_texture.position
		GameManager.card_moved.connect(_on_card_moved)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and highlighted:
		if not placed:
			selected = true
			if GameManager.selected_card != null:
				GameManager.selected_card.set_unselected()
			GameManager.selected_card = self
		else:
			GameManager.current_level.move_card_table_to_hand(self)

func set_unselected():
	selected = false
	GameManager.selected_card = null
	var tween = get_tree().create_tween()
	tween.tween_property(card_texture, "position", texture_original_pos, 0.2).set_trans(Tween.TRANS_LINEAR)


func _on_card_moved(_card: Card):
	var tween = get_tree().create_tween()
	tween.tween_property(card_texture, "position", texture_original_pos, 0.2)
	set_unselected()
	
func _on_texture_rect_mouse_entered() -> void:
	if locked:
		return

	var tween = get_tree().create_tween()
	if placed:
		tween.tween_property(card_texture, "position", texture_original_pos - Vector2(0, 10), 0.2).set_trans(Tween.TRANS_LINEAR)
	else:
		tween.tween_property(card_texture, "position", texture_original_pos - Vector2(0, 100), 0.2).set_trans(Tween.TRANS_LINEAR)
	highlighted = true


func _on_texture_rect_mouse_exited() -> void:
	if locked:
		return

	if not selected:
		var tween = get_tree().create_tween()
		tween.tween_property(card_texture, "position", texture_original_pos, 0.2).set_trans(Tween.TRANS_LINEAR)
	highlighted = false
