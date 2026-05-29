extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer
var property

#TODO: CLEAN COUNTER
func _ready() -> void:
	Global.cleanProgress = self
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
