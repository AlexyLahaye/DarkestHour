extends CharacterBody3D

@onready var anim:AnimationPlayer = $AnimationPlayer


const SPEED = 3.0
var ANIM_DIE = "red_side_slime.tscn::Animation_nvhxt"
var ANIM_WALKING = "slime_anim/slime_walk"
var ANIM_ATTACK = "red_side_slime.tscn::Animation_nvhxt"

@onready var enemy = ""
@onready var on_first = false
@onready var on_first_position

func _ready():
	_get_enemy()

func _physics_process(delta):
	anim.play(ANIM_WALKING, 0.2)

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(GameState.attack_cursor)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(GameState.default_cursor)

func _on_area_3d_body_entered(body):
	var groups:Array = body.get_groups()
	for group in groups:
		if group == enemy:
			if on_first == false:
				on_first_position = body.global_position
				on_first = true

func _on_area_3d_body_exited(body):
	var groups:Array = body.get_groups()
	for group in groups:
		if group == enemy:
			if on_first == true:
				on_first = false
				

func _get_enemy():
	var self_group = self.get_groups()
	if self_group[0] == "red_side":
		enemy = "blue_side"
	else:
		enemy = "red_side"
	

