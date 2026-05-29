extends Node

var debug

var cleaned : int = 0
var totalTrash : int = 0

signal change_clean_count(new_count, total)

func registerTrash():
	totalTrash += 1
	emit_signal("change_clean_count", cleaned, totalTrash)

func addCleaned():
	cleaned += 1
	emit_signal("change_clean_count", cleaned, totalTrash)

func resetTrash():
	cleaned = 0
	totalTrash = 0
	emit_signal("change_clean_count", cleaned, totalTrash)
