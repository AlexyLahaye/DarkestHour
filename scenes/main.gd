extends Node3D

@export var camera_pivot:Node3D

func _ready():
	_find_perso(2)
	_enter_level("default", "twisted_Treeline")

func _enter_level(from:String, to:String, use_spawn_point:bool = true):
	if (GameState.current_level != null): GameState.current_level.queue_free()
	GameState.current_level = load("res://maps/" + to + ".tscn").instantiate()
	GameState.current_level_key = to
	add_child(GameState.current_level)
	if (GameState.player.perso ):
		pass
	if (use_spawn_point):
		for spawnpoint:SpawnPoint in GameState.current_level.find_children("", "SpawnPoint"):
			if (spawnpoint.key == from):
				GameState.player.position = spawnpoint.position
				GameState.player.rotation = spawnpoint.rotation

func _find_perso(numPerso):
	var perso_scene = load("res://scenes/perso_"+ str(numPerso) +".tscn")
	var perso = perso_scene.instantiate()
	perso.camera_pivot = $CameraPivot
	GameState.player = perso
	add_child(perso)
	
