extends Control

var price_setting = false

@onready var client_id = randi_range(1,5)

func _ready():
	client_id = randi_range(1,5)
	print('client_id: ',_get_client_id())


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
