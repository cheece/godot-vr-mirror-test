extends MeshInstance


onready var cam_l = $L/Camera
onready var cam_r = $R/Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var origin: ARVROrigin

var nbasis:Basis
var ibasis:Basis

var w_scale:float

func update():
	if(ARVRServer.primary_interface && ARVRServer.primary_interface.interface_is_initialized):
		nbasis = global_transform.basis#.orthonormalized()
		ibasis = nbasis.inverse()
		w_scale = global_transform.basis.x.length() 
		
		update_eye(ARVRInterface.EYE_LEFT,cam_l)
		update_eye(ARVRInterface.EYE_RIGHT,cam_r)
func update_eye(eye, cam: Camera):
	var pi = ARVRServer.primary_interface
	var tx = pi.get_transform_for_eye(eye, origin.global_transform)
	
	var p = ibasis*(tx.origin- global_transform.origin)
	p.z*=-1
	cam.global_transform.basis = Basis(-nbasis.x,nbasis.y, -nbasis.z)
	cam.global_transform.origin = global_transform.origin +  nbasis*p
	#print(abs(p.z))
	cam.set_frustum(w_scale,Vector2( p.x,-p.y), abs(p.z),10000)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var m = get_surface_material(0)
	m.set("shader_param/texture_L", $L.get_texture())
	m.set("shader_param/texture_R", $R.get_texture())
		
	origin = get_tree().root.find_node("ARVROrigin" ,true,false)
	assert(origin)
	VisualServer.connect("frame_pre_draw",self,"update")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
