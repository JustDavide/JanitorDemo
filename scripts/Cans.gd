extends Node3D

func _ready() -> void:
	Global.registerTrash()

func clean():
	Global.addCleaned()
	queue_free()
