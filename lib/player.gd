class_name Player extends CharacterBody3D

signal start_moving()
signal moving()
signal stop_moving()
signal hit(node:Node3D)


@export var camera_pivot:Node3D
@export var perso:int = 1

@onready var anim:AnimationPlayer = $AnimationPlayer 
@onready var character:Node3D = $Character
var walking_speed:float = 3.5

#const numPerso = GameState.mainMenu.numPerso
var ANIM_STANDING = "torch_anim_p"+ str(2) + "/torch_idle"
var ANIM_WALKING = "torch_anim_p"+ str(2) + "/torch_walk"
var ANIM_RUNNING = "torch_anim_p"+ str(2) + "/torch_run"
var ANIM_FIRST_SKILL = "torch_anim_p"+ str(2) + "/basic_aa_anim"
var ANIM_SECOND_SKILL = "torch_anim_p"+ str(2) + "/heal_rage"
var ANIM_DEATH = "torch_anim_p"+ str(2) + "/death_anim"
var ANIM_DANCE = "torch_anim_p"+ str(2) + "/dance_anim"

var camera:IsometricCamera

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# for move_and_slide()
var speed:float = 0.0
var fall_acceleration:float = 200.0
var target_velocity:Vector3 = Vector3.ZERO

# isometric current view rotation
var current_view:int = 0
# player movement signaled
var signaled:bool = false

var is_updated_once = false
# mouse
var target = null

const directions = {
	"forward" : 	[  { 'x':  1, 'z': -1 },  { 'x':  1, 'z':  1 },  { 'x': -1, 'z':  1 },  { 'x': -1, 'z': -1 } ],
	"left" : 		[  { 'x': -1, 'z': -1 },  { 'x':  1, 'z': -1 },  { 'x':  1, 'z':  1 },  { 'x': -1, 'z':  1 } ],
	"backward" : 	[  { 'x': -1, 'z':  1 },  { 'x': -1, 'z': -1 },  { 'x':  1, 'z': -1 },  { 'x':  1, 'z':  1 } ],
	"right" : 		[  { 'x':  1, 'z':  1 },  { 'x': -1, 'z':  1 },  { 'x': -1, 'z': -1 },  { 'x':  1, 'z': -1 } ]
}

#BASIC STATS
var max_health = 1500
var health = 1500
var health_regen = 3
var mana = 350
var mana_regen = 5
var attack_damage = 45

var player_alive = true

#Gestion des sors
var first_skill_enable = true
var first_skill_cd
var second_skill_enable = true
var second_skill_cd
var basic_skill_enable = true
var basic_skill_cd

#Gestion des coups
var hit_area:Area3D
var attacking:bool = false

func _ready():
	camera = camera_pivot.get_node("Camera")
	anim.play(ANIM_STANDING, 0.2)
	hit_area = character.get_node("/Player/HitArea")
	#hit_area.connect("body_entered", _on_hit_area_body_entered)
func _input(event):
	if Input.is_action_pressed("forward"):
		select_position_to_go(get_viewport().get_mouse_position(), camera)
	if Input.is_action_pressed("first_skill"):
		if $FirstSkillCD.is_stopped():
			$FirstSkillCD.start()
			anim.play(ANIM_FIRST_SKILL, 0.2)
			attacking = true
			first_skill_enable = false
	if Input.is_action_pressed("second_skill"):
		if $SecondSkillCD.is_stopped():
			$SecondSkillCD.start()
			anim.play(ANIM_SECOND_SKILL, 0.2)
			health += 200
			second_skill_enable = false
	if Input.is_action_pressed("basic_skill"):
		if $BasicSkillCD.is_stopped():
			$BasicSkillBuffTimer.start()
			$BasicSkillCD.start()
			walking_speed = 5
			basic_skill_enable = false
	if Input.is_action_pressed("dance"):
		anim.play(ANIM_DANCE, 0.2)
	if Input.is_action_just_pressed("spacebar"):
		_update_camera()

func select_position_to_go(mouse_pos:Vector2, camera:Camera3D):
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = camera.project_ray_origin(mouse_pos)
	ray_query.to = ray_query.from + camera.project_ray_normal(mouse_pos) * 2000
	ray_query.collision_mask = 0x1
	var iray = get_world_3d().direct_space_state.intersect_ray(ray_query)
	if (iray.size() > 0):
		target = iray["position"]

func _physics_process(delta):
	if first_skill_enable == false:
		first_skill_cd = str(int($FirstSkillCD.time_left))
	if second_skill_enable == false:
		second_skill_cd = str(int($SecondSkillCD.time_left))
	if basic_skill_enable == false:
		basic_skill_cd = str(int($BasicSkillCD.time_left))
	
	if not is_on_floor():
		velocity.y -= gravity * delta;
	update_health_bar()
	if health <= 0:
		player_alive = false
		health = 0
		print("player_dead")
		anim.play(ANIM_DEATH, 0.2)
	
	#Gestion des déplacements
	if is_updated_once == false:
		_update_camera()
		is_updated_once = true
	if target:
		target.y = position.y
		look_at(target, Vector3.UP)
		velocity = -transform.basis.z * walking_speed
		if walking_speed < 5:
			anim.play(ANIM_WALKING, 0.2)
		else:
			anim.play(ANIM_RUNNING, 0.2)
		if transform.origin.distance_to(target) < .2:
			target = Vector3.ZERO
			velocity = Vector3.ZERO
			signaled = false
			stop_moving.emit()
			anim.play(ANIM_STANDING, 0.2)
	move_and_slide()

func _update_camera():
	camera_pivot.position = position
	camera_pivot.position.y += 1.5
	if (!signaled) :
		start_moving.emit()
		signaled = true

func update_health_bar():
	var health_bar = $SubViewport/HealthBar
	health_bar.value = health

func _on_regen_timer_timeout():
	if health < max_health:
		health += health_regen
	if health <= 0:
		health = 0
		
func _on_hit_area_body_entered(body):
	if(attacking):
		hit.emit(body)


func _on_basic_skill_buff_timer_timeout():
	walking_speed = 3.5


func _on_first_skill_cd_timeout():
	first_skill_enable = true


func _on_second_skill_cd_timeout():
	second_skill_enable = true


func _on_basic_skill_cd_timeout():
	basic_skill_enable = true


func _on_animation_player_animation_started(anim_name):
	#A VOIR MARCHE PAS LE CANCEL DEPLACEMENT
	#velocity = Vector3(0,0,0)
	pass
