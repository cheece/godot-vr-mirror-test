extends Spatial



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	var VR = ARVRServer.find_interface("OpenXR")
	if VR and VR.initialize():
		get_viewport().arvr = true
 
		# Also, the physics FPS in the project settings is also 90 FPS. This makes the physics
		# run at the same frame rate as the display, which makes things look smoother in VR!
