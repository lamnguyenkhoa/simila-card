extends Node

signal card_moved(card)
signal level_finished(level_id)

@export var start_menu: PackedScene
@export var level_list: Array[PackedScene]

var current_level: Level
var selected_card: Card
var highest_level_id: int = 0 # Level_id equal or lower than this are unlocked

func update_current_level(level: Level):
    current_level = level
    if current_level.level_id > highest_level_id:
        highest_level_id = current_level.level_id


func finish_level():
    emit_signal("level_finished", current_level.level_id)