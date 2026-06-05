extends Node3D

var tooltip
var interact = InputMap.get_action_description("Interact")
var maxInvLabel

func _ready() -> void:
	Global.registerTrash()
	tooltip = Global.playerUI.get_node("Tooltip")
	maxInvLabel = Global.playerUI.get_node("MaxInv")
	maxInvLabel.modulate.a = 0.0
	$Area3D.area_entered.connect(_on_area_entered)
	$Area3D.area_exited.connect(_on_area_exited)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		hold()
	
func _on_area_entered(area: Node3D):
	if area.get_parent().name == "Player":
		tooltip.text = "Press %s to clean" % interact
		tooltip.visible = true
	
func _on_area_exited(area: Node3D):
	if area.get_parent().name == "Player":
		tooltip.visible = false

func hold():
	var areas = $Area3D.get_overlapping_areas()
	for area in areas:
		if area.get_parent().name == "Player":
			if Global.trashHeld != Global.maxInventory:
				Global.addHeld()
				queue_free()
			else:
				maxInvLabel.modulate.a = 1.0
				maxInvLabel.visible = true
				
				var tween = create_tween() # first time using ts idk what I'm doing
				tween.tween_interval(2.0)
				tween.tween_property(maxInvLabel, "modulate:a", 0.0, 0.5)
				tween.tween_callback(func(): maxInvLabel.visible = false)
				# looks good? might change it later
