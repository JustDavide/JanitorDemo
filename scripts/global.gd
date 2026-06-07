extends Node

var debug
var playerUI

var trashHeld : int = 0
var maxInventory : int = 3 # Possible inventory system and/or upgrades? idk. possible

var cleaned : int = 0
var totalTrash : int = 0

signal change_clean_count(new_count, total)
signal change_held_count(new_held, total)

func registerTrash() -> void:
	totalTrash += 1
	emit_signal("change_clean_count", cleaned, totalTrash)

func addCleaned(count: int) -> void:
	cleaned += count
	emit_signal("change_clean_count", cleaned, totalTrash)

func resetTrash() -> void: # For level resetting/level changing
	cleaned = 0
	totalTrash = 0
	emit_signal("change_clean_count", cleaned, totalTrash)

func addHeld() -> void:
	trashHeld += 1
	emit_signal("change_held_count", trashHeld, maxInventory)

func removeHeld(count: int) -> void:
	trashHeld -= count
	emit_signal("change_held_count", trashHeld, maxInventory)

func hide_info() -> void:
	var tooltip = playerUI.get_node("Tooltip")
	tooltip.visible = false
