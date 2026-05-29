extends RayCast3D

func _process(_delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if Input.is_action_just_pressed("Interact"):
			stuff_cleaned(hit)

func stuff_cleaned(cleaned):
	var cans = cleaned.get_parent()

	if cans.has_method("clean"):
		cans.clean()
	else:
		push_error("This trash does not have the clean method. Name: " + cleaned.name)
