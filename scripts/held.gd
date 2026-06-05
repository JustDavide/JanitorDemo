extends Label

func _ready() -> void:
	Global.change_held_count.connect(on_held_change)
	text = "Held: 0/%d" % Global.maxInventory
	
func on_held_change(held: int, maxInv: int):
	text = "Held: %d/%d" % [held, maxInv]
