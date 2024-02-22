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
#var past_events = []

#Create Event Arrays
var event_positive = []
var event_neutral = []
var event_negative = []


signal card_selection_ready
signal card_reading_options(option_a, option_b, up_key_1, up_key_2, up_key_3, rev_key_1, rev_key_2, rev_key_3, client_question)

signal sel_done

var selection_choice

#win and fail state bools. If either endstate is reached, signal emits (true if win)
var endgame = false
var endgame_win

var happy = false

func _ready():
	_sort_events()
	turn()

func _new_location(location_resource):
	var loc_path = "res://assets/location_resources/"+location_resource+".tres"
	$player_board.location_resource = load(loc_path)
	$player_board._establish_game_board()

func turn():
	#Check right away to see if they've won or lost
	if endgame:
		get_parent().get_parent()._endgame(endgame_win)
	
	
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

#Sort events into their respective arrays
func _sort_events():
	var number_of_events = 61
	for event_id in number_of_events:
		print(event_id)
		var event_path = 'res://assets/random_event_resources/event_'+str(event_id+1)+'.tres'
		var event_resource = ResourceLoader.load(event_path)
		if event_resource.event_alliance == 'Positive':
			event_positive.append(event_resource)
		if event_resource.event_alliance == 'Neutral':
			event_neutral.append(event_resource)
		if event_resource.event_alliance == 'Negative':
			event_negative.append(event_resource)

#Checks Karma and determines if event should be Positive, Neutral or Negative
func _karma_police():
	var karma = $karma_bar.value
	var good_chance: float
	var neutral_chance: float
	var negative_chance: float
	
	# If Karma is 'good'
	if karma > 71 and karma <= 100:
		good_chance = 0.8
		neutral_chance = 0.1
		negative_chance = 0.1
	# If Karma is 'okay'
	elif karma > 41 and karma <= 70:
		good_chance = 0.1
		neutral_chance = 0.8
		negative_chance = 0.1
	# If Karma is 'bad'
	else:
		good_chance = 0.1
		neutral_chance = 0.1
		negative_chance = 0.8
	
	var random_value = randf()
	print(random_value)
	print('good_chance', good_chance)
	print('neutral_chance', neutral_chance)
	print('negative_chance', negative_chance)
		
	# Check the ranges to determine which value to return
	if random_value < good_chance:
		return 'good'
	elif random_value < good_chance + neutral_chance:
		return 'neutral'
	else:
		return 'negative'

#Write a func to spit out random event
func _new_event():
	print('karma is: ', $karma_bar.value)
	
	$client_parent/Control/client.visible = false
	$dialogue_box.visible = false
	_event_fade(true)
	
	var karma_outcome = _karma_police()
	var event_resource
	var random_index
	var random_value
	
	if karma_outcome == 'good':
		print('Event Positive Array Size: ', event_positive.size())
		random_index = randi() % event_positive.size()
		random_value = event_positive[random_index]
		event_resource = random_value
		event_positive.erase(event_resource)
		print('Event Positive Array Size: ', event_positive.size())
	if karma_outcome == 'neutral':
		print('Event Neutral Array Size: ', event_neutral.size())
		random_index = randi() % event_neutral.size()
		random_value = event_neutral[random_index]
		event_resource = random_value
		event_neutral.erase(event_resource)
		print('Event Neutral Array Size: ', event_neutral.size())
	if karma_outcome == 'negative':
		print('Event Negative Array Size: ', event_negative.size())
		random_index = randi() % event_negative.size()
		random_value = event_negative[random_index]
		event_resource = random_value
		event_negative.erase(event_resource)
		print('Event Negative Array Size: ', event_negative.size())
	
	#Load Event
	print('Loading Event - Event ID:', event_resource.event_id)
	print('Event Text: ',event_resource.event_text)
	
	#Little timeout for a pause between clients
	var t = Timer.new()
	self.add_child(t)
	t.start(1)
	await t.timeout
	$dialogue_box.visible = true
	
	t.queue_free()
	$dialogue_box/name_tag.visible = false
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
	_client_fade(true)
	$dialogue_box.visible = true
	$dialogue_box/name_tag.visible = true
	$dialogue_box/name_tag/name_tag_text.text = client.client_resource.client_name
	
	t.queue_free()
	_dialogue_tree(1)
	
#Event Fade
func _event_fade(in_true):
	var t_4 = Timer.new()
	var t_5 = Timer.new()
	
	if in_true:
		print('Event Modulate starting: ', $random_event.modulate.a)
		$random_event.visible = true
		add_child(t_4)
		while $random_event.modulate.a <= 1:
			$random_event.modulate.a += 0.1
			t_4.start(0.003)
			await t_4.timeout
		t_4.queue_free()
			
	if !in_true:
		print('Event Modulate starting: ', $random_event.modulate.a)
		add_child(t_5)
		while $random_event.modulate.a >= 0:
			$random_event.modulate.a -= 0.1
			t_5.start(0.003)
			await t_5.timeout
		t_5.queue_free()
		$random_event.visible = false

#Client Fade
func _client_fade(in_true):
	var t_4 = Timer.new()
	var t_5 = Timer.new()
	
	if in_true:
		print('client Modulate starting: ', $client_parent/Control/client/GboxClientPortrait1.modulate.a)
		$client_parent/Control/client/GboxClientPortrait1.visible = true
		add_child(t_4)
		while $client_parent/Control/client/GboxClientPortrait1.modulate.a <= 1:
			$client_parent/Control/client/GboxClientPortrait1.modulate.a += 0.1
			t_4.start(0.003)
			await t_4.timeout
		t_4.queue_free()
			
	if !in_true:
		print('client Modulate starting: ', $client_parent/Control/client/GboxClientPortrait1.modulate.a)
		add_child(t_5)
		while $client_parent/Control/client/GboxClientPortrait1.modulate.a >= 0:
			$client_parent/Control/client/GboxClientPortrait1.modulate.a -= 0.1
			t_5.start(0.003)
			await t_5.timeout
		t_5.queue_free()
		$client_parent/Control/client/GboxClientPortrait1.visible = false

#Reader Fade
func _reader_fade(in_true):
	var t_4 = Timer.new()
	var t_5 = Timer.new()
	
	if in_true:
		print('CutIn Modulate starting: ', $cut_in.modulate.a)
		$dialogue_box/name_tag.visible = false
		$cut_in.visible = true
		add_child(t_4)
		while $cut_in.modulate.a <= 1:
			$cut_in.modulate.a += 0.1
			t_4.start(0.003)
			await t_4.timeout
		t_4.queue_free()
			
	if !in_true:
		print('CutIn Modulate starting: ', $cut_in.modulate.a)
		add_child(t_5)
		while $cut_in.modulate.a >= 0:
			$cut_in.modulate.a -= 0.1
			t_5.start(0.003)
			await t_5.timeout
		t_5.queue_free()
		$cut_in.visible = false
		
		$dialogue_box/name_tag.visible = true
	


func _dialogue_tree(dialogue_count):
	var final_reaction
	
	if dialogue_count==1:
		$dialogue_box._next_text(client.client_resource.question)
		print('early adding +1 to count.')
		$dialogue_box.count += 1
		print('New count:', $dialogue_box.count)
		


	if dialogue_count==2:
		card_selection_ready.emit()
		var card_node = $"../reading_scene/reading_scene/AspectRatioContainer2/card"
		
		card_reading_options.emit(card_node.reading_upright,card_node.reading_reversed, card_node.upright_keyword_1, card_node.upright_keyword_2, card_node.upright_keyword_3, card_node.reversed_keyword_1, card_node.reversed_keyword_2, card_node.reversed_keyword_3, client.client_resource.question, client.client_resource.client_name)
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
		$dialogue_box.visible = false
		await sel_done
		$dialogue_box.visible = true
	
		print('signal received - selection is: ',selection_choice)
		
		if selection_choice == 'a':
			var result = _reaction_calculator(card_node,'upright')
			
			if result == 0:
				print('happyhappy')
				happy = true
				$dialogue_box._texture_swap(false)
				#final_reaction = client.client_resource.reaction_positive
				$dialogue_box._next_text(flavour_text_upright)
				_reader_fade(true)
				#await _update_bars(randi_range(1,10), randi_range(1,10), randi_range(1,10))
				#$dialogue_box._next_text(client.client_resource.reaction_positive)
			
			if result == 1 or result == 2:
				print('sadsad')
				happy = false
				$dialogue_box._texture_swap(false)
				#final_reaction = client.client_resource.reaction_negative
				$dialogue_box._next_text(flavour_text_upright)
				_reader_fade(true)
				#await _update_bars(randi_range(-1,-10), randi_range(-1,-10), randi_range(-1,-10))
				#$dialogue_box._next_text(client.client_resource.reaction_negative)
			
			


		if selection_choice == 'b':
			var result = _reaction_calculator(card_node,'reversed')
			
			if result == 0:
				print('happyhappy')
				happy = true
				$dialogue_box._texture_swap(false)
				#final_reaction = client.client_resource.reaction_positive
				$dialogue_box._next_text(flavour_text_reversed)
				_reader_fade(true)
				#await _update_bars(randi_range(1,10), randi_range(1,10), randi_range(1,10))
				#$dialogue_box._next_text(client.client_resource.reaction_positive)
			
			if result == 1 or result == 2:
				print('sadsad')
				happy = false
				$dialogue_box._texture_swap(false)
				#final_reaction = client.client_resource.reaction_negative
				$dialogue_box._next_text(flavour_text_reversed)
				_reader_fade(true)
				#await _update_bars(randi_range(-1,-10), randi_range(-1,-10), randi_range(-1,-10))
				#$dialogue_box._next_text(client.client_resource.reaction_negative)
			
		
		print('mid adding +1 to count.')
		$dialogue_box.count += 1
		print('New count:', $dialogue_box.count)
	
	#final Dialogue
	
	if dialogue_count==3:
		print('Client is happy?: ', happy)
		print("Final reaction will be, ", client.client_resource.reaction_positive)
		_reader_fade(false)
		
		if happy:
			$dialogue_box.visible = false
			await _update_bars(randi_range(10,30), randi_range(10,30), randi_range(10,30))
			$dialogue_box.visible = true
			$client_parent/Control/client/reaction_happy.visible = true
			$dialogue_box._texture_swap(true)
			$dialogue_box._next_text(client.client_resource.reaction_positive)
		if !happy:
			$dialogue_box.visible = false
			await _update_bars(randi_range(-5,-25), randi_range(-5,-25), randi_range(-5,-25))
			$dialogue_box.visible = true
			$client_parent/Control/client/reaction_angry.visible = true
			$dialogue_box._texture_swap(true)
			$dialogue_box._next_text(client.client_resource.reaction_negative)
		
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
	
	print('new_rep ',new_reputation)
	print('new_karma ',new_karma)
	print('new_gold ',new_gold)
	
	
	if new_reputation >=1:
		for i in new_reputation:
			$reputation_bar.value += 1
			#print('rep',$reputation_bar.value)
			t_1.start(0.03)
			await t_1.timeout
	
	if new_karma >=1: 
		for i in new_karma:
			$karma_bar.value += 1
			#print('kar',$karma_bar.value)
			t_2.start(0.03)
			await t_2.timeout
	
	if new_gold >= 1:
		for i in new_gold:
			$gold_bar.value += 1
			#print('gold',$gold_bar.value)
			t_3.start(0.03)
			await t_3.timeout

	if new_reputation <=-1:
		var neg_new_reputation = abs(new_reputation)
		for i in neg_new_reputation:
			$reputation_bar.value -= 1
			#print('rep',$reputation_bar.value)
			t_1.start(0.03)
			await t_1.timeout
	
	if new_karma <=-1:
		var neg_new_karma = abs(new_karma)
		for i in neg_new_karma:
			$karma_bar.value -= 1
			#print('kar',$karma_bar.value)
			t_2.start(0.03)
			await t_2.timeout
	
	if new_gold <=-1:
		var neg_new_gold = abs(new_gold)
		for i in neg_new_gold:
			$gold_bar.value -= 1
			#print('gold',$gold_bar.value)
			t_3.start(0.03)
			await t_3.timeout


		
	t_1.queue_free()
	t_2.queue_free()
	t_3.queue_free()

	#Here we'll have a victory state calculator - Flag get's raised when Reputation == 100
	if $reputation_bar.value >= 100:
		endgame = true
		endgame_win = true
	if $gold_bar.value <= 0:
		endgame = true
		endgame_win = false

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
