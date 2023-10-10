extends Control

var price_setting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$dialogue_window/dialogue_text.visible_characters += 1
	
	if $dialogue_window/dialogue_text.visible_ratio == 1:
		$dialogue_window/Button.visible = true


func _on_gold_slider_value_changed(value):
	$gold_slider/Label.text = str(value)


func _on_button_pressed():
	$gold_bar.value += $gold_slider.value


func _on_button_pressed_2():
	$dialogue_window/dialogue_text.text = 'Set your price for the reading.'
	$dialogue_window/dialogue_text.visible_ratio = 0
	$gold_slider.visible = true
