extends Node3D
@export var target : Node3D

func _zero_position():
	$Sprite3D.position = Vector3(0,0.49,0)
	$Sprite3D2.position = Vector3(-1,0.35,0)
	$Sprite3D3.position = Vector3(1,0.35,0)
	$Sprite3D4.position = Vector3(-2,0,0)
	$Sprite3D5.position = Vector3(2,0,0)
