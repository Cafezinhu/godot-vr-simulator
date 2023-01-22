extends ARVRController

var x_axis = 0
var y_axis = 0
var grip_axis = 0
var trigger_axis = 0
var buttons = []

func _ready():
	for _i in range(16):
		buttons.append(false)

func get_controller_name():
	return "Simulated controller"
	
func get_is_active():
	return true

func get_joystick_axis(axis):
	if axis == 0:
		return x_axis
	elif axis == 1:
		return y_axis
	elif axis == 2:
		return trigger_axis
	elif axis == 4:
		return grip_axis
	return 0

func get_joystick_id():
	return 1

func is_button_pressed(button: int):
	return buttons[button]

func press_button(button: int):
	buttons[button] = true
	emit_signal("button_pressed", button)

func release_button(button: int):
	buttons[button] = false
	emit_signal("button_release", button)
