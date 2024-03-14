extends Node

var current_level
var current_level_key = "twisted_Treeline"
var player:Player
var cameraTest:Camera3D
var camera:CameraState = CameraState.new()
var default_cursor:Resource = load("res://models/img/28x28px/Cursor Default.png")
var attack_cursor:Resource = load("res://models/img/28x28px/Cursor Mini Attack Red-1.png")
