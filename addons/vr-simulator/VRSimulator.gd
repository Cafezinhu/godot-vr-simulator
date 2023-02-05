extends Node

export var enabled: bool
export var device_x_sensitivity: float = 1
export var device_y_sensitivity: float = 1
export var scroll_sensitivity: float = 1
export var xr_origin: NodePath

const SimulatedController = preload("res://addons/vr-simulator/SimulatedController.gd")

var origin: ARVROrigin
var camera: ARVRCamera
var simulated_left_controller: SimulatedController
var simulated_right_controller: SimulatedController

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
	
	origin = get_node(xr_origin)
	
	for child in origin.get_children():
		if child.get("controller_id"):
			if child.controller_id == 1:
				child.set_script(SimulatedController)
				simulated_left_controller = child
			elif child.controller_id == 2:
				child.set_script(SimulatedController)
				simulated_right_controller = child
	
func _ready():
	if enabled:
		camera = origin.get_node("ARVRCamera")

func _input(event):
	if not enabled:
		return
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
		else:
			camera_height(event)
	elif event is InputEventKey:
		if Input.is_physical_key_pressed(KEY_Q):
			simulate_buttons(event, simulated_left_controller)
		elif Input.is_physical_key_pressed(KEY_E):
			simulate_buttons(event, simulated_right_controller)

func camera_height(event: InputEventMouseButton):
	var direction = -1
	
	if not event.pressed:
		return
	
	if event.button_index == BUTTON_WHEEL_UP:
		direction = 1
	elif event.button_index != BUTTON_WHEEL_DOWN:
		return
	
	var pos = camera.transform.origin
	camera.transform.origin = Vector3(pos.x, pos.y + (scroll_sensitivity * direction)/20 , pos.z)

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
	movement += camera.global_transform.basis.x * event.relative.x * device_x_sensitivity/1000
	movement += camera.global_transform.basis.y * event.relative.y * -device_y_sensitivity/1000
	controller.global_translate(movement)
	
func attract_controller(event: InputEventMouseButton, controller: SimulatedController):
	var direction = -1
	
	if not event.pressed:
		return
	
	if event.button_index == BUTTON_WHEEL_UP:
		direction = 1
	elif event.button_index != BUTTON_WHEEL_DOWN:
		return
	
	var distance_vector = controller.global_transform.origin - camera.global_transform.origin
	var forward = distance_vector.normalized() * direction
	var movement = distance_vector + forward * (scroll_sensitivity/20)
	if distance_vector.length() > 0.1 and movement.length() > 0.1:
		controller.global_translate(forward * (scroll_sensitivity/20))

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
