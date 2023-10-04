extends Node2D

@export var card_resource : CardResource
@onready var card_art_path = card_resource.card_art_path

var numby_poo = randi_range(2,4)
var prog_speed = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_art = Image.load_from_file(card_art_path)
	var card_name = card_resource.card_name
	var keyword_1 = card_resource.keyword_1
	var keyword_2 = card_resource.keyword_2
	var keyword_3 = card_resource.keyword_3
	$Path2D/PathFollow2D/GboxCardImage1.texture = ImageTexture.create_from_image(card_art)

#new function to load a new card resource
func _new_card():
	prog_speed = 0.05
	
	if numby_poo == 5:
		numby_poo = 1
	else:
		numby_poo +=1
	
	var card_resource = load('res://assets/card_resources/card_'+str(numby_poo)+'.tres')
	var card_art_path = card_resource.card_art_path
	var card_art = Image.load_from_file(card_art_path)
	var card_name = card_resource.card_name
	var keyword_1 = card_resource.keyword_1
	var keyword_2 = card_resource.keyword_2
	var keyword_3 = card_resource.keyword_3
	var rand_num = randi_range(1,6)
	$Path2D.curve = load('res://scenes/cards/curves/curve'+str(rand_num)+'.tres')
	$Path2D/PathFollow2D/GboxCardImage1.texture = ImageTexture.create_from_image(card_art)
	$Path2D/PathFollow2D.progress_ratio = randf_range(0.25,0.99)
	$Path2D.rotation_degrees = randi_range(-10,10)

func _process(delta):
	
	if $Path2D/PathFollow2D.progress_ratio < 0.96:
		$Path2D/PathFollow2D.progress_ratio += prog_speed
		if prog_speed >= 0.001:
			prog_speed -= 0.0025
	else:
		$Path2D/PathFollow2D.progress_ratio = 1
