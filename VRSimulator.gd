extends Node

export var enabled: bool
export var device_x_sensitivity: float = 1
export var device_y_sensitivity: float = 1
export var scroll_sensitivity: float = 1

const SimulatedController = preload("res://SimulatedController.gd")

var origin: ARVROrigin
var camera: ARVRCamera
var simulated_left_controller: SimulatedController = SimulatedController.new()
var simulated_right_controller: SimulatedController = SimulatedController.new()

var key_map = {
	KEY_1: 1,
	KEY_2: 2,
	KEY_3: 3,
	KEY_4: 4,
	KEY_5: 5,
	KEY_6: 6,
	KEY_7: 7,
	KEY_8: 8,
	KEY_9: 9,
	KEY_0: 10,
	KEY_MINUS: 11,
	KEY_EQUAL: 12,
	KEY_BACKSPACE: 13,
	KEY_ENTER: 14
}

func _enter_tree():
	if not enabled:
		return
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	origin = get_child(0)
	simulated_left_controller = SimulatedController.new()
	simulated_right_controller = SimulatedController.new()
	
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
	
	var new_name = controller.name
	print(new_name)
	
	for controller_child in controller.get_children():
		controller.remove_child(controller_child)
		simulated_controller.add_child(controller_child)
		
	simulated_controller.controller_id = controller.controller_id
	simulated_controller.transform = controller.transform
	controller.get_parent().remove_child(controller)
	controller.queue_free()
	simulated_controller.name = new_name

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	simulate_joysticks()
	
	if event is InputEventMouseMotion:
		if Input.is_physical_key_pressed(KEY_Q):
			if Input.is_key_pressed(KEY_SHIFT):
				rotate_device(event, simulated_left_controller)
			else:
				move_controller(event, simulated_left_controller)
		elif Input.is_physical_key_pressed(KEY_E):
			if Input.is_key_pressed(KEY_SHIFT):
				rotate_device(event, simulated_right_controller)
			else:
				move_controller(event, simulated_right_controller)
		else:
			rotate_device(event, camera)
	elif event is InputEventMouseButton:
		if Input.is_physical_key_pressed(KEY_Q):
			attract_controller(event, simulated_left_controller)
			simulate_trigger(event, simulated_left_controller)
			simulate_grip(event, simulated_left_controller)
		elif Input.is_physical_key_pressed(KEY_E):
			attract_controller(event, simulated_right_controller)
			simulate_trigger(event, simulated_right_controller)
			simulate_grip(event, simulated_right_controller)
	elif event is InputEventKey:
		if Input.is_physical_key_pressed(KEY_Q):
			simulate_buttons(event, simulated_left_controller)
		elif Input.is_physical_key_pressed(KEY_E):
			simulate_buttons(event, simulated_right_controller)

func simulate_joysticks():
	var vec_left = vector_key_mapping(KEY_D, KEY_A, KEY_W, KEY_S)
	
	simulated_left_controller.x_axis = vec_left.x
	simulated_left_controller.y_axis = vec_left.y
	
	var vec_right = vector_key_mapping(KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN)
	
	simulated_right_controller.x_axis = vec_right.x
	simulated_right_controller.y_axis = vec_right.y

func simulate_trigger(event: InputEventMouseButton, controller: SimulatedController):
	if event.button_index == BUTTON_LEFT:
		if event.pressed:
			controller.press_button(15)
		else:
			controller.release_button(15)

func simulate_grip(event: InputEventMouseButton, controller: SimulatedController):
	if event.button_index == BUTTON_RIGHT:
		controller.grip_axis = int(event.pressed)
		if event.pressed:
			controller.press_button(2)
		else:
			controller.release_button(2)

func simulate_buttons(event: InputEventKey, controller: SimulatedController):
	if key_map.has(event.scancode):
		var button = key_map[event.scancode]
		if event.pressed:
			controller.press_button(button)
		else:
			controller.release_button(button)

func move_controller(event: InputEventMouseMotion, controller: SimulatedController):
	var movement = Vector3()
	movement += camera.transform.basis.x * event.relative.x * device_x_sensitivity/1000
	movement += camera.transform.basis.y * event.relative.y * -device_y_sensitivity/1000
	controller.translate(movement)
	
func attract_controller(event: InputEventMouseButton, controller: SimulatedController):
	var direction = -1
	
	if event.button_index == BUTTON_WHEEL_UP:
		direction = 1
	elif event.button_index != BUTTON_WHEEL_DOWN:
		return
	
	var forward = (controller.transform.origin - camera.transform.origin).normalized() * direction
	if forward.length() == 0:
		forward = camera.transform.basis.z * -direction
	
	controller.translate(forward * (scroll_sensitivity/10))

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
