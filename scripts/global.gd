extends Node

var debug
var playerUI

var trashHeld : int = 0
var maxInventory : int = 3 # Possible inventory system and/or upgrades? idk. possible

var cleaned : int = 0
var totalTrash : int = 0

signal change_clean_count(new_count, total)
signal change_held_count(new_held, total)

func registerTrash():
	totalTrash += 1
	emit_signal("change_clean_count", cleaned, totalTrash)

func addCleaned(count: int):
	cleaned += count
	emit_signal("change_clean_count", cleaned, totalTrash)

func resetTrash(): # For level resetting/level changing
	cleaned = 0
	totalTrash = 0
	emit_signal("change_clean_count", cleaned, totalTrash)

func addHeld():
	trashHeld += 1
	emit_signal("change_held_count", trashHeld, maxInventory)

func removeHeld(count: int):
	trashHeld -= count
	emit_signal("change_held_count", trashHeld, maxInventory)
