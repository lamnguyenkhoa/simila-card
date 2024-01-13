extends Node

signal card_moved(card)

var current_level: Level
var selected_card: Card
var highest_level_id: int # Level_id equal or lower than this are unlocked