extends StaticBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("VRSimulator/FPController/LeftHandController").connect("button_pressed", self, "nada")
	pass # Replace with function body.

func nada(button: int):
	print("nada")
	print(button)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
