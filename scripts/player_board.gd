extends Node

@export var location_resource : LocationResource
# Whole script needs updated if any additional types of points are required

@export var place_text = 'Reading Event'

@export var reading_mod = 0
@export var event_mod = 0
@export var tax_mod = 0

var location_name
var number_of_readings
var number_of_random_events
var taxman_penalty
var number_of_taxman_locations
var player_place = 0

var chance_landing_on_event
var chance_landing_on_reading
var chance_landing_on_taxman
var total_points

#tile trackers
var turns_since_reading = 0
var turns_since_event = 0
var turns_since_tax = 0

#location switching
var ready_to_move = false

func _ready():
	_establish_game_board()
	#_move_player()

func _input(event):
	if event.is_action_pressed("nextRoll"):
		_move_player()

#func to track num of turns since last type of tile
func _distance_tracker():
	#reset distance == 0 if currently on said tile
	if place_text == 'Reading Event':
		turns_since_reading =0
		turns_since_event +=1
		turns_since_tax +=1
	if place_text == 'Random Event':
		turns_since_reading +=1
		turns_since_event =0
		turns_since_tax +=1
	if place_text == 'TAXMAN':
		turns_since_reading +=1
		turns_since_event +=1
		turns_since_tax =0


func _move_player():
	var roll = _diceroll()
	await _second_countdown(true,roll)
	player_place += roll
	#print('The player moved forward ', roll, ' places. They landed on: ', player_place) 
	place_text = _tile_chance_calculator('Reading Event', chance_landing_on_reading,turns_since_reading, 'Random Event', chance_landing_on_event,turns_since_event, 'TAXMAN', chance_landing_on_taxman, turns_since_tax) 
	print(place_text)
	_tax_tracker()
	_distance_tracker()
	
	#Max number of spaces moved before
	#you have the choice to move
	#the choice to move \/
	if player_place >= 10000000:
		ready_to_move = true
	
func _tax_tracker():
	var tax_positions = []
	
	var taxpoint_differences = total_points / (number_of_taxman_locations+1)
	#print(total_points, taxpoint_differences)

func _diceroll():
	var roll = randi_range(1,6)
	#print('roll :', roll)
	return roll

func _establish_game_board():
	location_name = location_resource.location_name
	number_of_readings = location_resource.number_of_readings
	number_of_random_events = location_resource.number_of_random_events
	taxman_penalty = location_resource.taxman_penalty
	number_of_taxman_locations = location_resource.number_of_taxman_locaions
	total_points = (number_of_readings+number_of_random_events+number_of_taxman_locations)
	#print(location_name)
	
	chance_landing_on_event = int(float(number_of_random_events)/(total_points)*100)
	chance_landing_on_reading = int(float(number_of_readings)/(total_points)*100)
	chance_landing_on_taxman = int(float(number_of_taxman_locations)/(total_points)*100)
	
	#print('The chance of landing on a random event is: %', chance_landing_on_event)
	#print('The chance of landing on a random reading is: %', chance_landing_on_reading)
	#print('The chance of landing on a taxman is: %', chance_landing_on_taxman)

#Works the % chance for landing on each type of tile
func _tile_chance_calculator(tile_1, chance_1, mod_1, tile_2, chance_2, mod_2, tile_3, chance_3, mod_3):
	#create array for storing chances
	var total_chances = []
	
	#reading chance Modifier
	mod_1 = mod_1*reading_mod
	
	#event chance Modifier
	mod_2 = mod_2*event_mod+1
	
	#tax chance Modifier
	mod_3 = mod_3*tax_mod
	
	var chance_total = chance_1+mod_1+chance_2+mod_2+chance_3+mod_3
	print('----------------NEW TURN-----------------')
	print('total chance for reading: ', int((float(chance_1+mod_1)/chance_total)*100) )
	print('total chance for event: ', int((float(chance_2+mod_2)/chance_total)*100) )
	print('total chance for tax: ', int((float(chance_3+mod_3)/chance_total)*100) )
	
	for nums in chance_1+mod_1:
		total_chances.push_back(tile_1)
	for nums in chance_2+mod_2:
		total_chances.push_back(tile_2)
	for nums in chance_3+mod_3:
		total_chances.push_back(tile_3)
	
	return total_chances.pick_random()

func _second_countdown(run, for_long):
	var count = 0
	var t = Timer.new()
	self.add_child(t)
	while run:
		t.start(0.25)
		await t.timeout
		#print(count)
		count +=1
		if count == for_long:
			run = false
