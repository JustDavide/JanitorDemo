extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 5.6
const RAYLENGHT = 5
@export var SENS = 0.03

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var debugCamera = $"../DebugCamera"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("M1"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("SwitchCamera"):
		if get_viewport().get_camera_3d() == camera:
			debugCamera.current = true
		else:
			camera.current = true
		
		
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			return
		head.rotate_y(-event.relative.x * SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-95), deg_to_rad(95))
		
	

func _physics_process(delta: float) -> void:
	Global.debug.add_property("Current X Velocity", "%.2f" % velocity.x, 1)
	Global.debug.add_property("Current Z Velocity", "%.2f" % velocity.z, 2)
	Global.debug.add_property("Curreny Y Velocity", "%.2f" % velocity.y, 3)
	Global.debug.add_property("On Ground?", is_on_floor(), 4)
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if (Input.is_action_pressed("Run") and is_on_floor()) and SPEED < 8:
		SPEED += 0.750
		if SPEED > 7.5:
			SPEED = 7.5
	
	if Input.is_action_just_released("Run"):
		SPEED = 5.0	

	var input_dir = Input.get_vector("Left", "Right", "Forwards", "Backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
		
		
