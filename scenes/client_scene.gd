extends Control

@onready var timer = Timer.new()


var price_setting = false


func _text_box_update():
	while $dialogue_window/dialogue_text.visible_ratio <1:
		timer.start(0.02)
		if $dialogue_window/dialogue_text.visible_ratio < 1:
			$dialogue_window/dialogue_text.visible_characters += 1
			print($dialogue_window/dialogue_text.visible_ratio)
			$dialogue_window/AudioStreamPlayer.playing = true
		await timer.timeout


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = true
	timer.set_paused(false)
	self.add_child(timer)
	print(timer.time_left)
	
	_text_box_update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	print(timer.time_left)
	
	if $dialogue_window/dialogue_text.visible_ratio == 1:
		print(1)
		$dialogue_window/AudioStreamPlayer.playing = false
		if price_setting == false:
			$dialogue_window/Button.visible = true
	#else:
	#	$dialogue_window/AudioStreamPlayer.playing = true


func _on_gold_slider_value_changed(value):
	$gold_slider/Label.text = str(value)


func _on_button_pressed():
	$gold_bar.value += $gold_slider.value 
	$gold_slider.visible = false


func _on_button_pressed_2():
	$dialogue_window/dialogue_text.text = 'Set your price for the reading.'
	$dialogue_window/dialogue_text.visible_ratio = 0
	
	while $dialogue_window/dialogue_text.visible_ratio <1:
		_text_box_update()
		await timer.timeout
		
	$gold_slider.visible = true
	price_setting = true
	$dialogue_window/Button.visible = false
