extends Control

var price_setting = false
var client 

var client_id = randi_range(1,5)

#func entertree():
#	client_id = randi_range(1,5)

func _ready():
	client = $client_parent/Control/client
	print('Client_scene: ',Time.get_ticks_msec(),'client_id: ',_get_client_id())
	print(client.client_resource.client_context)
	$dialogue_box._first_text(client.client_resource.client_context)


func _on_gold_slider_value_changed(value):
	$gold_slider/Label.text = str(value)


func _on_button_pressed():
	$gold_bar.value += $gold_slider.value 
	$gold_slider.visible = false

func _make_gold_visible():
	$gold_slider.visible = true


func _on_dialogue_box_choose_price(is_visible):
	$gold_slider.visible = is_visible

func _get_client_id():
	return client_id
