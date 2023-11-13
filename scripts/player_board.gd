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

func _ready():
	_establish_game_board()
	_1_sec_timer(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _establish_game_board():
	location_name = location_resource.location_name
	number_of_readings = location_resource.number_of_readings
	number_of_random_events = location_resource.number_of_random_events
	taxman_penalty = location_resource.taxman_penalty
	number_of_taxman_locations = location_resource.number_of_taxman_locaions
	print(location_name)
	
	chance_landing_on_event = int(float(number_of_random_events)/(number_of_readings+number_of_random_events)*100)
	chance_landing_on_reading = int(float(number_of_readings)/(number_of_readings+number_of_random_events)*100)
	print('The chance of landing on a random event is: %', chance_landing_on_event)
	print('The chance of landing on a random reading is: %', chance_landing_on_reading)

func _1_sec_timer(run):
	var count = 0
	var t = Timer.new()
	self.add_child(t)
	while run:
		t.start(0.25)
		await t.timeout
		print(count)
		count +=1
