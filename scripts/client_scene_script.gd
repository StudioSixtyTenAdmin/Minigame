extends Control

var swap_location = preload('res://scenes/swap_location.tscn')

var price_setting = false
signal price_set

var client 

var client_id #= randi_range(1,5)
var client_count = 0

var location_count = 2

var event_id
var event_count = 0
var dialogue_count=0
var client_scenario_running = true
var past_clients = []
var past_events = []

signal card_selection_ready
signal card_reading_options(option_a, option_b)

signal sel_done

var selection_choice

func _ready():
	turn()

func _new_location(location_resource):
	var loc_path = "res://assets/location_resources/"+location_resource+".tres"
	$player_board.location_resource = load(loc_path)
	$player_board._establish_game_board()

func turn():
	dialogue_count = 0
	$dialogue_box.visible = false
	$random_event.visible = false
	await $player_board._move_player()
	if $player_board.place_text == 'Reading Event' and !$player_board.ready_to_move:
		_new_client()
		
		
	if $player_board.place_text == 'Random Event' and !$player_board.ready_to_move or $player_board.place_text == 'TAXMAN' and !$player_board.ready_to_move :
		_new_event()
		
		
	if $player_board.ready_to_move:
		_move_scenario()
		

func _move_scenario():
	$client_parent/Control/client.visible = false
	$dialogue_box.visible = false
	$random_event.visible = false
	
	print('READY TO MOVE READY TO MOVE READY TO MOVE')
	add_child(swap_location.instantiate())
	var are_we_moving = await $swap_location.location_move_choice
	
	print(are_we_moving)
	#Present Player with choice to move location!
	if !are_we_moving:
		print('WE SHALL REMAIN')
		$player_board.ready_to_move = false
		$player_board.player_place = 0
		
	if are_we_moving:
	#If they choose to move! The following applies
		print('... moving from: ',$player_board.location_resource.location_name)
		print('... to... ')
		_new_location('location_'+str(location_count))
		$player_board.ready_to_move = false
		$player_board.player_place = 0
		event_count = 0
		$gold_bar.value -= 10
		
		print('... we have now moved to: ', $player_board.location_resource.location_name)	
	
	remove_child(get_node('swap_location'))
	turn()

#Write a func to spit out random event
func _new_event():
	$client_parent/Control/client.visible = false
	$dialogue_box.visible = false
	$random_event.visible = true
	
	#Ensure event hasn't happened before
	var valid_event = false
	while !valid_event:
		if event_count >= $player_board.location_resource.number_of_random_events:
			get_tree().quit()
		
		event_id = randi_range(1,$player_board.location_resource.number_of_random_events)
		#print('checking client id: ',client_id)
		if past_events.has(event_id):
			valid_event= false
		else:
			valid_event= true
	past_events.append(event_id)
	
	#Load Event
	var event_path = 'res://assets/random_event_resources/event_'+str(event_id)+'.tres'
	#print(event_path)
	var event_resource = ResourceLoader.load(event_path)
	
	#Little timeout for a pause between clients
	var t = Timer.new()
	self.add_child(t)
	t.start(1)
	await t.timeout
	$dialogue_box.visible = true
	
	t.queue_free()
	$dialogue_box._random_event(event_resource.event_text)
	
	#Update Values from Event
	_update_bars(event_resource.rep_change,event_resource.karma_change,event_resource.gold_change)

func _new_client():
	print('running NEW CLIENT')
	$client_parent/Control/client.visible = false
	$dialogue_box.visible = false
	$dialogue_box.event = false
	
	client_count+=1
	var valid_client = false
	while !valid_client:
		if client_count >= $player_board.location_resource.number_of_readings:
			get_tree().quit()
		
		client_id = randi_range(1,$player_board.location_resource.number_of_readings)
		#print('checking client id: ',client_id)
		if past_clients.has(client_id):
			valid_client= false
		else:
			valid_client= true
	past_clients.append(client_id)
	#print('client ID: ', client_id)
	client = $client_parent/Control/client
	client._update_client()
	
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
	var final_reaction
	var happy = false
	
	if dialogue_count==1:
		$dialogue_box._next_text(client.client_resource.question)
		print('early adding +1 to count.')
		$dialogue_box.count += 1
		print('New count:', $dialogue_box.count)
		


	if dialogue_count==2:
		card_selection_ready.emit()
		var card_node = $"../reading_scene/reading_scene/AspectRatioContainer2/card"

		card_reading_options.emit(card_node.reading_upright,card_node.reading_reversed)
		var flavour = _card_flavour_calculator(card_node)
		var flavour_text_upright
		var flavour_text_reversed
		
		if flavour == 'moral':
			flavour_text_upright = card_node.upright_moral
			flavour_text_reversed = card_node.reversed_moral
			
		if flavour == 'business/political':
			flavour_text_upright = card_node.upright_bus_pol
			flavour_text_reversed = card_node.reversed_bus_pol
			
		if flavour == 'love':
			flavour_text_upright = card_node.upright_love
			flavour_text_reversed = card_node.reversed_love
			
		if flavour == 'natural':
			flavour_text_upright = card_node.upright_nature
			flavour_text_reversed = card_node.reversed_nature
		
		print('card selection ready')
		await sel_done
	
		print('signal received - selection is: ',selection_choice)
		
		if selection_choice == 'a':
			var result = _reaction_calculator(card_node,'upright')
			
			if result == 0:
				happy = true
				$dialogue_box._texture_swap(false)
				final_reaction = client.client_resource.reaction_positive
				$dialogue_box._next_text(flavour_text_upright)
				#await _update_bars(randi_range(1,10), randi_range(1,10), randi_range(1,10))
				#$dialogue_box._next_text(client.client_resource.reaction_positive)
			
			if result == 1 or result == 2:
				$dialogue_box._texture_swap(false)
				final_reaction = client.client_resource.reaction_positive
				$dialogue_box._next_text(flavour_text_upright)
				#await _update_bars(randi_range(-1,-10), randi_range(-1,-10), randi_range(-1,-10))
				#$dialogue_box._next_text(client.client_resource.reaction_negative)
			
			


		if selection_choice == 'b':
			var result = _reaction_calculator(card_node,'reversed')
			
			if result == 0:
				happy = true
				#final_reaction = client.client_resource.reaction_positive
				$dialogue_box._texture_swap(false)
				$dialogue_box._next_text(flavour_text_reversed)
				#await _update_bars(randi_range(1,10), randi_range(1,10), randi_range(1,10))
				#$dialogue_box._next_text(client.client_resource.reaction_positive)
			
			if result == 1 or result == 2:
				#final_reaction = client.client_resource.reaction_positive
				$dialogue_box._texture_swap(false)
				$dialogue_box._next_text(flavour_text_reversed)
				#await _update_bars(randi_range(-1,-10), randi_range(-1,-10), randi_range(-1,-10))
				#$dialogue_box._next_text(client.client_resource.reaction_negative)
			
		
		print('mid adding +1 to count.')
		$dialogue_box.count += 1
		print('New count:', $dialogue_box.count)
	
	#final Dialogue
	
	if dialogue_count==3:
		print('Client is happy?: ', happy)
		print("Final reaction will be, ", client.client_resource.reaction_positive)
		
		if happy:
			await _update_bars(randi_range(1,10), randi_range(1,10), randi_range(1,10))
			$dialogue_box._texture_swap(true)
			$dialogue_box._next_text(client.client_resource.reaction_positive)
		if !happy:
			await _update_bars(randi_range(-1,-10), randi_range(-1,-10), randi_range(-1,-10))
			$dialogue_box._texture_swap(true)
			$dialogue_box._next_text(client.client_resource.reaction_positive)
		
		print('last adding +1 to count.')
		$dialogue_box.count += 1
		print('New count:', $dialogue_box.count)
		
		
	dialogue_count+=1
	

#function to incrementally update various resource meters
func _update_bars(new_reputation, new_karma, new_gold):
	
	var t_1 = Timer.new()
	var t_2 = Timer.new()
	var t_3 = Timer.new()
	add_child(t_1)
	add_child(t_2)
	add_child(t_3)
	
	
	if new_reputation >=1:
		for i in new_reputation:
			$reputation_bar.value += 1
			print('rep',$reputation_bar.value)
			t_1.start(0.03)
			await t_1.timeout
	
	if new_karma >=1: 
		for i in new_karma:
			$karma_bar.value += 1
			print('kar',$karma_bar.value)
			t_2.start(0.03)
			await t_2.timeout
	
	if new_gold >= 1:
		for i in new_gold:
			$gold_bar.value += 1
			print('gold',$gold_bar.value)
			t_3.start(0.03)
			await t_3.timeout

	if new_reputation <=-1:
		var neg_new_reputation = abs(new_reputation)
		for i in new_reputation:
			$reputation_bar.value -= 1
			print('rep',$reputation_bar.value)
			t_1.start(0.03)
			await t_1.timeout
	
	if new_karma <=-1:
		var neg_new_karma = abs(new_karma)
		for i in new_karma:
			$karma_bar.value -= 1
			print('kar',$karma_bar.value)
			t_2.start(0.03)
			await t_2.timeout
	
	if new_gold <=-1:
		var neg_new_gold = abs(new_gold)
		for i in neg_new_gold:
			$gold_bar.value -= 1
			print('gold',$gold_bar.value)
			t_3.start(0.03)
			await t_3.timeout


		
	t_1.queue_free()
	t_1.queue_free()
	t_1.queue_free()

func _card_flavour_calculator(card):
	var card_flavour
	if client.client_resource.theme == 0:
		print('moral')
		return 'moral'
	if client.client_resource.theme == 1:
		print('business/political')
		return 'business/political'
	if client.client_resource.theme == 2:
		print('love')
		return 'love'
	if client.client_resource.theme == 3:
		print('natural')
		return 'natural'

#outputs reaction of client
func _reaction_calculator(card, position):
	var final_reaction
	if position == 'upright':
#		#upright compare
		#validation
		if client.client_resource.reason == 0:
			final_reaction = card.upright_validation 
		#practical
		if client.client_resource.reason == 1:
			final_reaction = card.upright_practical
		#spiritual
		if client.client_resource.reason == 2:
			final_reaction = card.upright_spiritual
		
	if position == 'reversed':
		#reversed compare
		if client.client_resource.reason == 0:
			final_reaction = card.reversed_validation 
		#practical
		if client.client_resource.reason == 1:
			final_reaction = card.reversed_practical
		#spiritual
		if client.client_resource.reason == 2:
			final_reaction = card.reversed_spiritual
	
	return final_reaction

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

#Demo fail state
#func _process(delta):
#	
#	if $gold_slider.value <= 0:
#		remove_child(get_node('Tar_Root_Scene'))
#	
