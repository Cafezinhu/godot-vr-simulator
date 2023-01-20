extends Node

export var enabled: bool
export var device_x_sensitivity: float = 1
export var device_y_sensitivity: float = 1

const SimulatedController = preload("res://SimulatedController.gd")

var origin: ARVROrigin
var camera: ARVRCamera
var left_controller: ARVRController
var right_controller: ARVRController
var simulated_left_controller: SimulatedController = SimulatedController.new()
var simulated_right_controller: SimulatedController = SimulatedController.new()

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	if not enabled:
		return
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	origin = get_child(0)
	simulated_left_controller = SimulatedController.new()
	simulated_left_controller.name = "SimulatedLeftController"
	simulated_right_controller = SimulatedController.new()
	simulated_right_controller.name = "SimulatedRightController"
	for child in origin.get_children():
		if child.get("controller_id"):
			if child.controller_id == 1:
				bind_simulated_controller(child, simulated_left_controller)
			elif child.controller_id == 2:
				bind_simulated_controller(child, simulated_right_controller)
	
	
func _ready():
	camera = origin.get_node("ARVRCamera")
	
func bind_simulated_controller(controller: ARVRController, simulated_controller: SimulatedController):
	origin.add_child(simulated_controller)
	
	for controller_child in controller.get_children():
		controller.remove_child(controller_child)
		simulated_controller.add_child(controller_child)
		
	simulated_controller.controller_id = controller.controller_id
	simulated_controller.transform = controller.transform
	controller.queue_free()


func _process(_delta):
	simulate_joysticks()
	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		if Input.is_physical_key_pressed(KEY_Q):
			pass
		elif Input.is_physical_key_pressed(KEY_E):
			pass
		else:
			rotate_device(event, camera)

func simulate_joysticks():
	var vec_left = vector_key_mapping(KEY_D, KEY_A, KEY_W, KEY_S)
	
	simulated_left_controller.x_axis = vec_left.x
	simulated_left_controller.y_axis = vec_left.y
	
	var vec_right = vector_key_mapping(KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN)
	
	simulated_right_controller.x_axis = vec_right.x
	simulated_right_controller.y_axis = vec_right.y
	
func rotate_device(event: InputEventMouseMotion, device: Spatial):
	var motion = event.relative
	device.rotate_y(motion.x * -device_x_sensitivity/1000)
	device.rotate(device.transform.basis.x, motion.y * -device_y_sensitivity/1000)
	
func vector_key_mapping(key_positive_x: int, key_negative_x: int, key_positive_y: int, key_negative_y: int):
	var x = 0
	var y = 0
	if Input.is_physical_key_pressed (key_positive_y):
		y = 1
	elif Input.is_physical_key_pressed (key_negative_y):
		y = -1
	
	if Input.is_physical_key_pressed (key_positive_x):
		x = 1
	elif Input.is_physical_key_pressed (key_negative_x):
		x = -1
	
	var vec = Vector2(x, y)
	
	if vec:
		vec = vec.normalized()
	
	return vec
