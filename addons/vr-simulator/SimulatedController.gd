extends ARVRController

var x_axis = 0
var y_axis = 0
var grip_axis = 0
var trigger_axis = 0
var buttons = []

var genuine_controller: ARVRController

func _ready():
	genuine_controller = ARVRController.new()
	genuine_controller.controller_id = controller_id
	get_parent().call_deferred("add_child", genuine_controller)
	genuine_controller.connect("button_pressed", self, "press_button")
	genuine_controller.connect("button_release", self, "release_button")
	for _i in range(16):
		buttons.append(false)

func get_controller_name():
	if genuine_controller.get_is_active():
		return genuine_controller.get_controller_name()
	return "Simulated controller"
	
func get_is_active():
	return true

func get_joystick_axis(axis):
	if genuine_controller.get_is_active():
		return genuine_controller.get_joystick_axis(axis)
	if axis == 0:
		return x_axis
	elif axis == 1:
		return y_axis
	elif axis == 2:
		return trigger_axis
	elif axis == 4:
		return grip_axis
	else:
		return genuine_controller.get_joystick_axis(axis)

func get_joystick_id():
	return genuine_controller.get_joystick_id()

func is_button_pressed(button: int):
	return buttons[button]

func press_button(button: int):
	buttons[button] = true
	emit_signal("button_pressed", button)

func release_button(button: int):
	buttons[button] = false
	emit_signal("button_release", button)
