extends Node3D

# Input Mapping
var interact = InputMap.get_action_description("Interact")

# UI Elements
var tooltip
var mopBar

# Other
var playerNear = false
var holdTime = 0.0
const HOLDDURATION = 4.5 # will have to lower, but idk. 
@onready var ogScale=$Puddle.scale

func _ready() -> void:
	Global.registerTrash()
	tooltip = Global.playerUI.get_node("Tooltip")
	mopBar = Global.playerUI.get_node("MopProgress")
	$Area3D.area_entered.connect(_on_area_entered)
	$Area3D.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area: Node3D):
	if area.get_parent().name == "Player":
		playerNear = true
		tooltip.text = "Hold %s (%.1fs) to clean" % [interact, HOLDDURATION]
		tooltip.visible = true

func _on_area_exited(area: Node3D):
	if area.get_parent().name == "Player":
		playerNear = false
		tooltip.visible = false
		tooltip.text = "Press %s to clean" % interact
		
func _process(delta: float) -> void:
	if playerNear and Input.is_action_pressed("Interact"):
		if not mopBar.visible:
			mopBar.visible = true
		
		holdTime += delta
		mopBar.value = holdTime / HOLDDURATION
		$Puddle.scale=ogScale*(1.01-mopBar.value)
		#$Area3D/CollisionShape3D.scale=ogScale/scale
		
		if holdTime >= HOLDDURATION:
			mop()
	else:
		if mopBar.visible:
			mopBar.visible = false
		#holdTime = 0.0
		#mopBar.value = 0

func mop():
	if mopBar.visible: # Failsafe
		mopBar.visible = false
		mopBar.value = 0
	Global.addCleaned()
	queue_free()
