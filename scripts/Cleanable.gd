extends Node3D

class_name Cleanable

# Input Mapping
var interact = InputMap.get_action_description("Interact")

# UI Elements
var tooltip
var mopBar
var maxInvLabel

# Other
var playerNear = false
var holdTime = 0.0
@export var holdDuration = 4.5 # will have to lower, but idk. 
@export var mustHold = false
var ogScale:Vector3

func _ready() -> void:
	if has_node("Puddle"):
		ogScale=$Puddle.scale
	Global.registerTrash()
	tooltip = Global.playerUI.get_node("Tooltip")
	mopBar = Global.playerUI.get_node("MopProgress")
	maxInvLabel = Global.playerUI.get_node("MaxInv")
	maxInvLabel.modulate.a = 0.0
	$Area3D.area_entered.connect(_on_area_entered)
	$Area3D.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Node3D):
	if area.get_parent().name == "Player":
		playerNear = true
		#tooltip.text = "Hold %s (%.1fs) to clean" % [interact, HOLDDURATION]
		#tooltip.visible = true

func _on_area_exited(area: Node3D):
	if area.get_parent().name == "Player":
		playerNear = false
		#tooltip.visible = false

func show_info() -> void:
	tooltip.text = "Hold %s (%.1fs) to clean" % [interact, holdDuration]
	tooltip.visible = true

func _process(delta: float) -> void:
	if playerNear and Input.is_action_pressed("Interact"):
		if not mopBar.visible:
			mopBar.visible = true
		
		holdTime += delta
		mopBar.value = holdTime / holdDuration
		if has_node("Puddle"):
			$Puddle.scale=ogScale*(1.01-mopBar.value)
		
		if mustHold:
			if Global.trashHeld != Global.maxInventory:
				if holdTime >= holdDuration:
					Global.addHeld()
					clean()
			else:
				if mopBar.visible:
					mopBar.visible = false
				if has_node("Puddle"):
					$Puddle.scale = ogScale
				holdTime = 0.0
				mopBar.value = 0
				
				maxInvLabel.modulate.a = 1.0
				maxInvLabel.visible = true
				
				var tween = create_tween()
				tween.tween_interval(2.0)
				tween.tween_property(maxInvLabel, "modulate:a", 0.0, 0.5)
				tween.tween_callback(func(): maxInvLabel.visible = false)
		elif holdTime >= holdDuration:
			clean()
	else:
		if mopBar.visible:
			mopBar.visible = false
		if has_node("Puddle"):
			$Puddle.scale = ogScale
		holdTime = 0.0
		mopBar.value = 0
		# Reset values and scale on player leaving the area/stop holding

func clean():
	if mopBar.visible: # Failsafe
		mopBar.visible = false
		mopBar.value = 0
	if not mustHold:
		Global.addCleaned(1)
	queue_free()
