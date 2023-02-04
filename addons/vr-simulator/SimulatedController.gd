extends ARVRController

var x_axis = 0
var y_axis = 0
var grip_axis = 0
var trigger_axis = 0
var buttons = []

func _ready():
	for _i in range(16):
		buttons.append(false)

func get_is_active():
	return true

func get_joystick_axis(axis):
	var base_axis = .get_joystick_axis(axis)
	if base_axis != 0:
		return base_axis
	
	if axis == 0:
		return x_axis
	elif axis == 1:
		return y_axis
	elif axis == 2:
		return trigger_axis
	elif axis == 4:
		return grip_axis
	else:
		return 0

func is_button_pressed(button: int):
	var is_base_pressed = .is_button_pressed(button)
	if not is_base_pressed:
		return buttons[button]
	return is_base_pressed

func press_button(button: int):
	buttons[button] = true
	emit_signal("button_pressed", button)

func release_button(button: int):
	buttons[button] = false
	emit_signal("button_release", button)
