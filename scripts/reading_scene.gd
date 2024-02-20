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
	$reading_scene._move_card()
	threed_card_root.visible = false
	$SubViewportContainer.visible = false


func _on_client_scene__card_reading_options(option_a, option_b, up_key_1, up_key_2, up_key_3, rev_key_1, rev_key_2, rev_key_3):
	$reading_scene/OptionA/keyword_1.text = "[center]"+up_key_1+"[/center]"
	$reading_scene/OptionA/keyword_2.text = "[center]"+up_key_2+"[/center]"
	$reading_scene/OptionA/keyword_3.text = "[center]"+up_key_3+"[/center]"
	$reading_scene/OptionB/keyword_1.text = "[center]"+rev_key_1+"[/center]"
	$reading_scene/OptionB/keyword_2.text = "[center]"+rev_key_2+"[/center]"
	$reading_scene/OptionB/keyword_3.text = "[center]"+rev_key_3+"[/center]"
	
	$Dialogue_Confirmation_Box_up/AspectRatioContainer/VBoxContainer/full_text.text = option_a
	$Dialogue_Confirmation_Box_rev/AspectRatioContainer/VBoxContainer/full_text.text = option_b


func _on_client_scene__card_selection_ready():
	print('card Selection Ready')
	$reading_scene._new_card()
	threed_card_root._reset()
	visible = true
	$reading_scene.visible = false
	threed_card_root.visible = true
	threed_card_root.click_ready = true
	$SubViewportContainer.visible = true
	print('card Selection finished')


func _on_option_a_pressed():
	$fade.visible = true
	$Dialogue_Confirmation_Box_up.visible = true
	#finish_reading_scene.emit('a')
	#print('reading a')
	#$reading_scene.visible = false
	


func _on_option_b_pressed():
	$fade.visible = true
	$Dialogue_Confirmation_Box_rev.visible = true
	#finish_reading_scene.emit('b')
	#print('reading b')
	#$reading_scene.visible = false


func _on_reverse_confirmed():
	finish_reading_scene.emit('a')
	print('reading a')
	$reading_scene.visible = false
	$Dialogue_Confirmation_Box_rev.visible = false
	$fade.visible = false


func _on_upright_confirmed():
	finish_reading_scene.emit('b')
	print('reading b')
	$reading_scene.visible = false
	$Dialogue_Confirmation_Box_up.visible = false
	$fade.visible = false


func _on_upright_confirm_canceled():
	$Dialogue_Confirmation_Box_rev.visible = false
	$Dialogue_Confirmation_Box_up.visible = false
	$fade.visible = false
