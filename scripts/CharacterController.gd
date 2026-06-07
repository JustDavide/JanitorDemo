extends CharacterBody3D

var SPEED = 10.0
const JUMP_VELOCITY = 5.6
const RAYLENGHT = 5
@export var SENS = 0.03

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.playerUI = $UI
	
func _unhandled_input(_event: InputEvent) -> void:
	# Mouse capture switch (until we get a pause menu or smth)
	if Input.is_action_just_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("M1"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			

func _physics_process(delta: float) -> void:
	# Debug Values just in case
	Global.debug.add_property("Current X Velocity", "%.2f" % velocity.x, 1)
	Global.debug.add_property("Current Z Velocity", "%.2f" % velocity.z, 2)
	Global.debug.add_property("Curreny Y Velocity", "%.2f" % velocity.y, 3)
	Global.debug.add_property("On Ground?", is_on_floor(), 4)
	
	# Don't really need gravity but I'll just keep it rn
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2

	var input_dir = Input.get_vector("Left", "Right", "Forwards", "Backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta*5.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta*5.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta*10.0)
		velocity.z = move_toward(velocity.z, 0.0, delta*10.0)
	
	# Camera smooth
	var head_height : float = 0.762
	var head_target_pos = global_position; head_target_pos.y += head_height
	# apply
	head.global_position = lerp(head.global_position, head_target_pos, delta*10.0)

	move_and_slide()
