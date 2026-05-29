extends RayCast3D


func _process(_delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if Input.is_action_just_pressed("Interact"):
			hit.queue_free()
