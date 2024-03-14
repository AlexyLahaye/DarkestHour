extends Path3D


var on_first = false
var on_first_position
var enemy = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_child(0).enemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	on_first = get_child(0).on_first
	on_first_position = get_child(0).on_first_position
	if on_first == true:
		var closest = $".".curve.get_closest_point(get_child(0).position)
		var offset = $".".curve.get_closest_offset(closest)
		var index = get_curve_point_index_from_offset($".".curve, offset)
		$".".curve.set_point_position(index, $".".to_local(on_first_position))
	
func get_curve_point_index_from_offset(curve, offset):
	var curve_point_length = curve.get_point_count()
	if curve_point_length < 2: return curve_point_length
	for i in range(1, curve.get_point_count()):
		var current_point_offset = curve.get_closest_offset(curve.get_point_position(i))
		if current_point_offset > offset: return i
	return curve_point_length
