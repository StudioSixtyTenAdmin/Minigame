extends Node3D

#@onready var a = $Camera3D.global_position
#@onready var b = $Camera3D.target.global_position

@onready var a = $fan_root.global_position
@onready var b = $fan_root.target.global_position

@onready var t = 0
@onready var current_card = $fan_root/Sprite3D
var move_card = false
@export var click_ready = false
signal card_selected 

func _reset():
	$fan_root._zero_position()
	var a = $fan_root.global_position
	var b = $fan_root.target.global_position
	t = 0
	current_card = $fan_root/Sprite3D
	move_card = false
	click_ready = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(t)
	a = $fan_root.global_position
	t += delta*2
	$fan_root.global_position = lerp(a,b,t)
	if($fan_root.global_position.distance_to(b))<0.05:
		a = b
	if move_card:
		current_card.position.y += t*2
		print(current_card.position.y)
		for child in $fan_root.get_children():
			if child != current_card:
				child.position.y -= t*2
				print(child.position.y)

func _on_area_3d_mouse_entered():
	#print('middle')
	current_card = $fan_root/Sprite3D
	t = 0
	b = Vector3(0,0,0)
	#b = Vector3(0,-7.579,8.462)
	#print(a,b)
	$fan_root/Sprite3D.position.z = 0.85
	$fan_root/Sprite3D2.position.z = 0
	$fan_root/Sprite3D3.position.z = 0
	$fan_root/Sprite3D4.position.z = 0
	$fan_root/Sprite3D5.position.z = 0
	#$Camera3D.target.position.x = 0

func _on_area_3d_2_mouse_entered():
	#print('mid_left')
	current_card = $fan_root/Sprite3D2
	t = 0
	b = Vector3(0.6,0,0)
	#b = Vector3(-1.25,-7.579,8.462)
	#print(a,b)
	$fan_root/Sprite3D.position.z = 0.
	$fan_root/Sprite3D2.position.z = 0.85
	$fan_root/Sprite3D3.position.z = 0
	$fan_root/Sprite3D4.position.z = 0
	$fan_root/Sprite3D5.position.z = 0
	#$Camera3D.target.position.x = -1

func _on_area_3d_3_mouse_entered():
	#print('mid_right')
	current_card = $fan_root/Sprite3D3
	t = 0
	b = Vector3(-0.6,0,0)
	#b = Vector3(1.25,-7.579,8.462)
	#print(a,b)
	$fan_root/Sprite3D.position.z = 0
	$fan_root/Sprite3D2.position.z = 0
	$fan_root/Sprite3D3.position.z = 0.85
	$fan_root/Sprite3D4.position.z = 0
	$fan_root/Sprite3D5.position.z = 0	
	#$Camera3D.target.position.x = 1

func _on_area_3d_4_mouse_entered():
	#print('far_left')
	current_card = $fan_root/Sprite3D4
	t = 0
	b = Vector3(1.5,0,0)
	#b = Vector3(-2.5,-7.579,8.462)
	#print(a,b)
	$fan_root/Sprite3D.position.z = 0
	$fan_root/Sprite3D2.position.z = 0
	$fan_root/Sprite3D3.position.z = 0
	$fan_root/Sprite3D4.position.z = 0.85
	$fan_root/Sprite3D5.position.z = 0
	#$Camera3D.target.position.x = -2

func _on_area_3d_5_mouse_entered():
	#print('far_right')
	current_card = $fan_root/Sprite3D5
	t = 0
	b = Vector3(-1.5,0,0)
	#b = Vector3(2.5,-7.579,8.462)
	#print(a,b)
	$fan_root/Sprite3D.position.z = 0
	$fan_root/Sprite3D2.position.z = 0
	$fan_root/Sprite3D3.position.z = 0
	$fan_root/Sprite3D4.position.z = 0
	$fan_root/Sprite3D5.position.z = 0.85
	#$Camera3D.target.position.x = 2

func _input(input):
	if input.is_action_pressed('mouseClick') and click_ready:
		click_ready = false
		move_card = true
		print(current_card)
		await get_tree().create_timer(0.4).timeout
		print('timeout')
		move_card = false
		card_selected.emit()
		_reset()
		
	if input.is_action_pressed("nextRoll"):
		click_ready = true
