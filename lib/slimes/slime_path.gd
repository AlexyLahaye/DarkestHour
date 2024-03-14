extends PathFollow3D

@onready var slime_path:PathFollow3D = $"."
var on_first = false
var on_first_position
var enemy = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_child(0).enemy

func _process(delta):
	on_first = get_child(0).on_first
	on_first_position = get_child(0).on_first_position
	#var new_point = get_parent().to_local(on_first_position)
	const slime_ms := 2.5
	slime_path.progress += slime_ms * delta
