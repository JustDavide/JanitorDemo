extends Label

func _ready() -> void:
	Global.change_clean_count.connect(on_count_changed)
	text = "Cleaned: 0/0"
	
func on_count_changed(cleaned: int, total: int):
	text = "Cleaned: %d/%d" % [cleaned, total]
