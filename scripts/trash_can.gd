extends Node3D

var tooltip
var interact = InputMap.get_action_description("Interact")

func _ready() -> void:
	tooltip = Global.playerUI.get_node("Tooltip")
	$Area3D.area_entered.connect(_on_area_entered)
	$Area3D.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area: Node3D):
	if area.get_parent().name == "Player":
		tooltip.text = "Press %s to dump all of your trash" % interact
		tooltip.visible = true
	
func _on_area_exited(area: Node3D):
	if area.get_parent().name == "Player":
		tooltip.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		clean()

func clean():
	var areas = $Area3D.get_overlapping_areas()
	for area in areas:
		if area.get_parent().name == "Player":
			Global.addCleaned(Global.trashHeld)
			Global.removeHeld(Global.trashHeld)
