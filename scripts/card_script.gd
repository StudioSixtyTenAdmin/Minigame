extends Node2D

@export var card_resource : CardResource
#@onready var card_art_path = card_resource.card_art_path

var numby_poo = randi_range(1,21)
var prog_speed = 0.05
var count = 0

var reading_upright
var reading_reversed

var upright_keyword_1
var upright_keyword_2
var upright_keyword_3
var reversed_keyword_1
var reversed_keyword_2
var reversed_keyword_3

var upright_validation
var upright_practical
var upright_spiritual
var reversed_validation
var reversed_practical
var reversed_spiritual

var upright_love
var reversed_love
var upright_bus_pol
var reversed_bus_pol
var upright_nature
var reversed_nature
var upright_moral
var reversed_moral

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var card_art = Image.load_from_file(card_art_path)
	#var keyword_1 = card_resource.keyword_1
	#var keyword_2 = card_resource.keyword_2
	#var keyword_3 = card_resource.keyword_3
	#$Path2D/PathFollow2D/GboxCardImage1.texture = card_art
	#$Path2D/PathFollow2D/GboxCardImage1.texture = ImageTexture.create_from_image(card_art)
	#$Keyword1.text = keyword_1
	#$Keyword2.text = keyword_2
	#$Keyword3.text = keyword_3

#new function to load a new card resource
func _new_card():
	var resource_path = 'res://assets/card_resources/card_'+str(numby_poo)+'.tres'
	print(resource_path)
	var card_resource = load(resource_path)
	var card_art_path = card_resource.card_art_path

	#var card_art = Image.load_from_file(card_art_path)
	var card_art = load(card_art_path)
	var card_name = card_resource.card_name
	
	$Path2D.curve = load('res://scenes/cards/curves/curve6.tres')
	$Path2D/PathFollow2D/GboxCardImage1.texture = card_art
	reading_upright = card_resource.upright_reading
	reading_reversed = card_resource.reversed_reading
	
	upright_keyword_1 = card_resource.upright_keyword_1
	upright_keyword_2 = card_resource.upright_keyword_2
	upright_keyword_3 = card_resource.upright_keyword_3
	reversed_keyword_1 = card_resource.reversed_keyword_1
	reversed_keyword_2 = card_resource.reversed_keyword_2
	reversed_keyword_3 = card_resource.reversed_keyword_3
	
	upright_validation = card_resource.upright_validation
	upright_practical = card_resource.upright_practical
	upright_spiritual = card_resource.upright_spiritual
	reversed_validation = card_resource.reversed_validation
	reversed_practical = card_resource.reversed_practical
	reversed_spiritual = card_resource.reversed_spiritual
	
	upright_love = card_resource.upright_love
	reversed_love = card_resource.reversed_love
	upright_bus_pol = card_resource.upright_bus_pol
	reversed_bus_pol = card_resource.reversed_bus_pol
	upright_nature = card_resource.upright_nature
	reversed_nature = card_resource.reversed_nature
	upright_moral = card_resource.upright_moral
	reversed_moral = card_resource.reversed_moral
	
	numby_poo = randi_range(1,21)

func _move_card():
	prog_speed = 0.05
	count = 0
	
	$Path2D/PathFollow2D.progress_ratio = 0.25 #randf_range(0.01,0.5)

func _process(delta):
	count += delta
	#if count < 0.2:
	#	if $Path2D/PathFollow2D/GboxCardImage1.rotation<0:
	#		$Path2D/PathFollow2D/GboxCardImage1.rotate(-delta)
	#	if $Path2D/PathFollow2D/GboxCardImage1.rotation>0:
	#		$Path2D/PathFollow2D/GboxCardImage1.rotate(+delta)

	if $Path2D/PathFollow2D.progress_ratio < 0.99:
		$Path2D/PathFollow2D.progress_ratio += prog_speed
		if prog_speed >= 0.001:
			prog_speed -= 0.0025
	else:
		$Path2D/PathFollow2D.progress_ratio += 1
		
	#$Keyword1.modulate = Color(1, 1, 1, 1)
	#$Keyword2.text = keyword_2
	#$Keyword3.text = keyword_3
