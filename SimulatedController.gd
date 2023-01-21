extends ARVRController

var x_axis = 0
var y_axis = 0
var grip_axis = 0
var is_trigger_pressed = false

func get_controller_name():
	return "Simulated controller"
	
func get_is_active():
	return true

func get_joystick_axis(axis):
	if axis == 0:
		return x_axis
	elif axis == 1:
		return y_axis
	elif axis == 4:
		return grip_axis
	return 0

func get_joystick_id():
	return 1

func is_button_pressed(button):
	if button == 15:
		return is_trigger_pressed
	return false

