extends Control

var price_setting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gold_slider_value_changed(value):
	$gold_slider/Label.text = str(value)


func _on_button_pressed():
	$gold_bar.value += $gold_slider.value 
	$gold_slider.visible = false

func _make_gold_visible():
	$gold_slider.visible = true


func _on_dialogue_box_choose_price(is_visible):
	$gold_slider.visible = is_visible
