extends Node

@export var location_resource : LocationResource
# Called when the node enters the scene tree for the first time.

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

func _ready():
	_establish_game_board()
	_move_player()

func _input(event):
	if event.is_action_pressed("nextRoll"):
		_move_player()

func _move_player():
	var roll = _diceroll()
	await _second_countdown(true,roll)
	player_place += roll
	print('The player moved forward ', roll, ' places. They landed on: ', player_place) 
	var place_text = _tile_chance_calculator('Reading Event', chance_landing_on_reading, 'Random Event', chance_landing_on_event, 'TAXMAN', chance_landing_on_taxman) 
	print(place_text)
	_tax_tracker()
	print('Players current place is:', player_place)
	
func _tax_tracker():
	var tax_positions = []
	
	var taxpoint_differences = total_points / (number_of_taxman_locations+1)
	#print(total_points, taxpoint_differences)

func _diceroll():
	var roll = randi_range(1,6)
	print('roll :', roll)
	return roll

func _establish_game_board():
	location_name = location_resource.location_name
	number_of_readings = location_resource.number_of_readings
	number_of_random_events = location_resource.number_of_random_events
	taxman_penalty = location_resource.taxman_penalty
	number_of_taxman_locations = location_resource.number_of_taxman_locaions
	total_points = (number_of_readings+number_of_random_events+number_of_taxman_locations)
	print(location_name)
	
	chance_landing_on_event = int(float(number_of_random_events)/(total_points)*100)
	chance_landing_on_reading = int(float(number_of_readings)/(total_points)*100)
	chance_landing_on_taxman = int(float(number_of_taxman_locations)/(total_points)*100)
	
	print('The chance of landing on a random event is: %', chance_landing_on_event)
	print('The chance of landing on a random reading is: %', chance_landing_on_reading)
	print('The chance of landing on a taxman is: %', chance_landing_on_taxman)


func _tile_chance_calculator(tile_1, chance_1, tile_2, chance_2, tile_3, chance_3):
	var total_chances = []
	for nums in chance_1:
		total_chances.push_back(tile_1)
	for nums in chance_2:
		total_chances.push_back(tile_2)
	for nums in chance_3:
		total_chances.push_back(tile_3)
	return total_chances.pick_random()

func _second_countdown(run, for_long):
	var count = 0
	var t = Timer.new()
	self.add_child(t)
	while run:
		t.start(0.25)
		await t.timeout
		print(count)
		count +=1
		if count == for_long:
			run = false
