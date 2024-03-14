class_name twisted_Treeline extends Node3D

@export var key:String

var current_level:twisted_Treeline
var current_level_key:String = "twisted_Treeline"
var player:CharacterBody3D
var is_wave_complete = false
const nb_slime_spawn = 4
var cpt = 0

# INSTANTIATION BLUE SIDE ET RED SIDE 
#**************************    RED     ****************************************

var red_side_bottom = load("res://scenes/red_side_bottom.tscn")
var red_side_top = load("res://scenes/red_side_top.tscn")

#**************************    BLUE    ****************************************
var blue_side_bottom = load("res://scenes/blue_side_bottom.tscn")
var blue_side_top = load("res://scenes/blue_side_top.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$wave_timer.start() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_wave_timer_timeout():
	if is_wave_complete != true:
		# RED SIDE
		var red_slime_b = red_side_bottom.instantiate()
		var red_slime_t = red_side_top.instantiate()
		$".".add_child(red_slime_b)
		$".".add_child(red_slime_t)
		# BLUE SIDE
		var blue_slime_b = blue_side_bottom.instantiate()
		var blue_slime_t = blue_side_top.instantiate()
		$".".add_child(blue_slime_b)
		$".".add_child(blue_slime_t)
		cpt += 1
	if cpt == 4:
		$wave_timer.wait_time = 30
		cpt = 0
	else:
		$wave_timer.wait_time = 0.7
	$wave_timer.start()
