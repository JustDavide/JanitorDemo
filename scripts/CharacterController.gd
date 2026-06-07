extends CharacterBody3D

var SPEED: float = 10.0
const JUMP_VELOCITY: float = 5.6
const RAYLENGHT: float = 5
@export var SENS: float = 0.03

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interaction_area: Area3D = $Area3D

var interactable_objects: Array[Node3D] = []

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.playerUI = $UI
	interaction_area.area_entered.connect(_on_area_entered)
	interaction_area.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Node3D):
	if area.get_parent().has_method("show_info"):
		interactable_objects.append(area)

func _on_area_exited(area: Node3D):
	interactable_objects.erase(area)

func _unhandled_input(_event: InputEvent) -> void:
	# Mouse capture switch (until we get a pause menu or smth)
	if Input.is_action_just_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("M1"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			

func _process(_delta: float) -> void:
	if not interactable_objects.is_empty():
		var closest_distance: float = INF
		var closest_object: Node3D = null
		for object in interactable_objects:
			if object.global_position.distance_squared_to(global_position) < closest_distance:
				closest_distance = object.global_position.distance_squared_to(global_position)
				closest_object = object
		closest_object.get_parent().show_info()
	else:
		Global.hide_info()

func _physics_process(delta: float) -> void:
	# Debug Values just in case
	Global.debug.add_property("Current X Velocity", "%.2f" % velocity.x, 1)
	Global.debug.add_property("Current Z Velocity", "%.2f" % velocity.z, 2)
	Global.debug.add_property("Curreny Y Velocity", "%.2f" % velocity.y, 3)
	Global.debug.add_property("On Ground?", is_on_floor(), 4)
	
	# Don't really need gravity but I'll just keep it rn
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2

	var input_dir: Vector2 = Input.get_vector("Left", "Right", "Forwards", "Backwards")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
