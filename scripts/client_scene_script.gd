extends Control

var price_setting = false
signal price_set
 
var client 

var client_id #= randi_range(1,5)
var client_count = 0
var dialogue_count=0
var client_scenario_running = true
var past_clients = []

signal card_selection_ready
signal card_reading_options(option_a, option_b)

signal sel_done

var selection_choice


func _ready():
	_new_client()
	
func _new_client():
	$client_parent/Control/client.visible = false
	$dialogue_box.visible = false
	
	client_count+=1
	var valid_client = false
	while !valid_client:
		if client_count >= 17:	
			get_tree().quit()
		
		client_id = randi_range(1,17)
		print('checking client id: ',client_id)
		if past_clients.has(client_id):
			valid_client= false
		else:
			valid_client= true
	past_clients.append(client_id)
	print('client ID: ', client_id)
	client = $client_parent/Control/client
	client._update_client()
	#card_reading_options.emit($Tar_Root_Scene/reading_scene/reading_scene/AspectRatioContainer2/card.upright_reading,$Tar_Root_Scene/reading_scene/reading_scene/AspectRatioContainer2/card.reversed_reading,)
	
	#Little timeout for a pause between clients
	var t = Timer.new()
	self.add_child(t)
	t.start(1)
	await t.timeout
	$client_parent/Control/client.visible = true
	$dialogue_box.visible = true
	
	t.queue_free()
	_dialogue_tree(1)
	
func _dialogue_tree(dialogue_count):
	#if dialogue_count==0:
	#	$dialogue_box._next_text(client.client_resource.client_context)
	if dialogue_count==1:
		$dialogue_box._next_text(client.client_resource.question)
	if dialogue_count==2:
		card_selection_ready.emit()
		card_reading_options.emit($Tar_Root_Scene/reading_scene/reading_scene/AspectRatioContainer2/card.upright_reading,$Tar_Root_Scene/reading_scene/reading_scene/AspectRatioContainer2/card.reversed_reading)
		print('card selection ready')
		await sel_done
	
		print('signal received - selection is: ',selection_choice)
		
		if selection_choice == 'a':
			$dialogue_box._next_text(client.client_resource.reaction_positive)
			$reputation_bar.value += 10
		if selection_choice == 'b':
			$dialogue_box._next_text(client.client_resource.reaction_negative)
			$reputation_bar.value -= 10
		
	#if dialogue_count==3:
	#	$dialogue_box._next_text(client.client_resource.reaction_positive)
	dialogue_count+=1

func _next_text():
	$dialogue_box._next_text(client.client_resource.question)

func _on_gold_slider_value_changed(value):
	$gold_slider/Label.text = str(value)


func _on_gold_button_pressed():
	print('Gold Button Pressed')
	$gold_bar.value += $gold_slider.value 
	$gold_slider.visible = false
	price_set.emit()

func _make_gold_visible():
	$gold_slider.visible = true


func _on_dialogue_box_choose_price(is_visible):
	$gold_slider.visible = is_visible

func _get_client_id():
	return client_id


func _on_reading_scene_finish_reading_scene(selection):
	print('reading finished in client scene')
	selection_choice = selection
	sel_done.emit()


func _on_button_pressed():
	#func _hide_main():
	print('Hide!')
	#get_parent().paused = true
	get_parent().visible = false
