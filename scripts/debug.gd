extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer

var property

func _ready() -> void:
	Global.debug = self
	visible = false

func _process(_delta):
	if not visible:
		pass
	
	add_property("FPS", Engine.get_frames_per_second(), 0)

func _input(event):
	if event.is_action_pressed("Debug"):
		visible = !visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = title + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
	
	
