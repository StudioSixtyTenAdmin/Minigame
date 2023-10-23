extends Control

var price_setting = false
signal price_set 
var client 

var client_id #= randi_range(1,5)
var client_count = 0
var dialogue_count=0
var client_scenario_running = true
var past_clients = []


func _ready():
	_new_client()
	
func _new_client():
	client_count+=1
	var valid_client = false
	while !valid_client:
		if client_count >= 5:	
			get_tree().quit()
		
		client_id = randi_range(1,5)
		print('checking client id: ',client_id)
		if past_clients.has(client_id):
			valid_client= false
		else:
			valid_client= true
	past_clients.append(client_id)
	print('client ID: ', client_id)
	client = $client_parent/Control/client
	client._update_client()
	_dialogue_tree(0)
	
func _dialogue_tree(dialogue_count):
	if dialogue_count==0:
		$dialogue_box._next_text(client.client_resource.client_context)
	if dialogue_count==1:
		$dialogue_box._next_text(client.client_resource.question)
	if dialogue_count==2:
		$dialogue_box._next_text(client.client_resource.reaction_positive)
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
