extends Node3D

# Input Mapping
var interact = InputMap.get_action_description("Interact")

# UI Elements
var tooltip
var mopBar

# Vars
var playerNear = false
var holdTime = 0.0
const HOLDDURATION = 4.5 # will have to lower, but idk. 

func _ready() -> void:
	Global.registerTrash()
	tooltip = Global.playerUI.get_node("Tooltip")
	mopBar = Global.playerUI.get_node("MopProgress")
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	
	
func _on_body_entered(body: Node3D):
	if body.name == "Player":
		playerNear = true
		tooltip.text = "Hold %s (%.1fs) to clean" % [interact, HOLDDURATION]
		tooltip.visible = true

func _on_body_exited(body: Node3D):
	if body.name == "Player":
		playerNear = false
		tooltip.visible = false
		tooltip.text = "Press %s to clean" % interact
		
func _process(delta: float) -> void:
	if playerNear and Input.is_action_pressed("Interact"):
		if not mopBar.visible:
			mopBar.visible = true
		
		holdTime += delta
		mopBar.value = holdTime / HOLDDURATION
		
		if holdTime >= HOLDDURATION:
			mop()
	else:
		if mopBar.visible:
			mopBar.visible = false
		holdTime = 0.0
		mopBar.value = 0

func mop():
	if mopBar.visible: # Failsafe
		mopBar.visible = false
		mopBar.value = 0
	Global.addCleaned()
	queue_free()
