extends Node3D

signal finish_reading_scene(selection)
@onready var threed_card_root = $SubViewportContainer/SubViewport/threed_card_root

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_d_card_root_card_selected():
	$reading_scene.visible = true
	$reading_scene._new_card()
	threed_card_root.visible = false
	$SubViewportContainer.visible = false


func _on_client_scene__card_reading_options(option_a, option_b):
	$reading_scene/AspectRatioContainer/UI/OptionA/RichTextLabel.text = option_a
	$reading_scene/AspectRatioContainer/UI/OptionB/RichTextLabel.text = option_b


func _on_client_scene__card_selection_ready():
	threed_card_root._reset()
	visible = true
	$reading_scene.visible = false
	threed_card_root.visible = true
	threed_card_root.click_ready = true
	$SubViewportContainer.visible = true


func _on_option_a_pressed():
	finish_reading_scene.emit('a')
	print('reading a')
	$reading_scene.visible = false
	


func _on_option_b_pressed():
	finish_reading_scene.emit('b')
	print('reading b')
	$reading_scene.visible = false
