extends Node2D

var settings_visible = false
var main_scene = preload('res://scenes/tar_root_scene.tscn')#
var running_scene
var game_started = false

# Settings Variables
@export var volume_value = 100
@export var typespeed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	if game_started == false:
		$VBoxContainer/Resume.visible = false
	$VBoxContainer/VBoxContainer.visible = settings_visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_value = $VBoxContainer/VBoxContainer/VolumeSlider.value
	$VBoxContainer/VBoxContainer/Volume.text = str("Volume - ", str($VBoxContainer/VBoxContainer/VolumeSlider.value))
	#volume_text = ("Volume - ", str($VBoxContainer/VBoxContainer/HSlider.value))
	$VBoxContainer/VBoxContainer.visible = settings_visible
	typespeed = $VBoxContainer/VBoxContainer/TextSpeedSlider.value


func _on_button_3_pressed():
	print(settings_visible)
	
	if settings_visible == false:
		settings_visible = true
		$VBoxContainer/Button3.text  = 'Close Settings'

	else:
		settings_visible = false
		$VBoxContainer/Button3.text  = 'Open Settings'
	print(settings_visible)


func _on_exit_pressed():
	get_tree().quit()


func _on_start_pressed():
	game_started = true
	if game_started == true:
		$VBoxContainer/Start.text = 'Restart Game'
		if is_instance_valid(get_node('Tar_Root_Scene')):
			remove_child(get_node('Tar_Root_Scene'))
		$VBoxContainer/Resume.visible = true
	running_scene = main_scene.instantiate()
	add_child(running_scene)

func _on_resume_pressed():
	get_node('Tar_Root_Scene').visible = true

func _endgame(result):
	#win if result = TRUE
	game_started = false
	$VBoxContainer/Start.text = 'New Game'
	$VBoxContainer/Resume.visible = false
	
	if !result:
		print('GAMEOVERGAMEOVERGAMEOVER')
		remove_child(running_scene)
		$PopupMenuFail.visible = true
	if result:
		print('winwinwinwinwinwinwinwin')
		remove_child(running_scene)
		$PopupMenuWin.visible = true


func _on_close_pressed():
	$GameLose.visible = false
