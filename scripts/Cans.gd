extends Node3D

var tooltip

func _ready() -> void:
	Global.registerTrash()
	tooltip = Global.playerUI.get_node("Tooltip")
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		clean()
	
func _on_body_entered(body: Node3D):
	if body.name == "Player":
		tooltip.visible = true
		
func _on_body_exited(body: Node3D):
	if body.name == "Player":
		tooltip.visible = false

func clean():
	var bodies = $Area3D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			Global.addCleaned()
			queue_free()
