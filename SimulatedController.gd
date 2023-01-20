extends ARVRController

var x_axis = 0
var y_axis = 0

func get_controller_name():
	return "Emulated controller"
	
func get_is_active():
	return true

func get_joystick_axis(axis):
	if axis == 0:
		return x_axis
	elif axis == 1:
		return y_axis
	return 0

func get_joystick_id():
	return 1

func is_button_pressed(button):
	return false
