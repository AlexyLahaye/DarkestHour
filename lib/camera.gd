class_name IsometricCamera extends Camera3D

signal view_rotate(view:int)

@export var object_to_follow_path: NodePath

const positions = [ Vector3(-50, 70, 50), Vector3(-50,60,-50), Vector3(50,70,-50),  Vector3(50,70,50) ]
const rotations = [ Vector3(-45, -45, 0), Vector3(-45,-135,0), Vector3(-45,-225,0), Vector3(-45,45,0) ]

@onready var camera_pivot:Node3D = $".."

# camera pivot
var object_to_follow:Node3D
# isometric view rotation
var _view:int = 0
# camera field of view
var _size:int = 15
# keyboard actions
var zoom_in = false
var zoom_out = false

func _ready():
	projection = Camera3D.PROJECTION_ORTHOGONAL
	position = Vector3(40.0, 10.0, -80.0)
	GameState.camera.size = 15.0 #Distance de base de la caméra
	30 / get_viewport().content_scale_factor
	_view = GameState.camera.view
	object_to_follow = camera_pivot
	zoom_view()
	rotate_view()

func _unhandled_input(event):
	if (event is InputEventMouseButton) and (not event.pressed):
		if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			zoom_view(2)
		elif (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			zoom_view(-2)

func _process(_delta):
	camera_pivot.position = object_to_follow.position
	if (zoom_in): 
		zoom_view(-.5)
	elif (zoom_out): 
		zoom_view(.5)

func zoom_view(delta:int=0):
	_size += delta
	_size = clamp(_size, 5, 15)
	size = _size
	GameState.camera.size = _size

func rotate_view(delta:int=0):
	_view += delta
	_view = clamp(_view, 0, 3)
	position = positions[_view]
	rotation_degrees = rotations[_view]
	GameState.camera.view = _view
	view_rotate.emit(_view)

func move(pos):
	camera_pivot.position = pos
