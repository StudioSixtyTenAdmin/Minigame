extends Node2D

@export var card_resource : CardResource
@onready var card_art_path = card_resource.card_art_path

var numby_poo = randi_range(1,21)
var prog_speed = 0.05
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_art = Image.load_from_file(card_art_path)
	var card_name = card_resource.card_name
	var keyword_1 = card_resource.keyword_1
	var keyword_2 = card_resource.keyword_2
	var keyword_3 = card_resource.keyword_3
	$Path2D/PathFollow2D/GboxCardImage1.texture = ImageTexture.create_from_image(card_art)
	$Keyword1.text = keyword_1
	$Keyword2.text = keyword_2
	$Keyword3.text = keyword_3

#new function to load a new card resource
func _new_card():
	prog_speed = 0.05
	count = 0
	
	#if numby_poo == 5:
	#	numby_poo = 1
	#else:
	#	numby_poo +=1
	
	var card_resource = load('res://assets/card_resources/card_'+str(numby_poo)+'.tres')
	var card_art_path = card_resource.card_art_path
	var card_art = Image.load_from_file(card_art_path)
	var card_name = card_resource.card_name
	var keyword_1 = card_resource.keyword_1
	var keyword_2 = card_resource.keyword_2
	var keyword_3 = card_resource.keyword_3
	#var rand_num = randi_range(1,6)
	#old random curve
	#$Path2D.curve = load('res://scenes/cards/curves/curve'+str(rand_num)+'.tres')
	$Path2D.curve = load('res://scenes/cards/curves/curve6.tres')
	$Path2D/PathFollow2D/GboxCardImage1.texture = ImageTexture.create_from_image(card_art)
	$Keyword1.text = keyword_1
	$Keyword2.text = keyword_2
	$Keyword3.text = keyword_3
	
	$Keyword1.set_position(Vector2(randf_range(0,126),randf_range(0,126)))
	$Keyword2.set_position(Vector2(randf_range(-126,0),randf_range(-126,0)))
	$Keyword3.set_position(Vector2(randf_range(-126,0),randf_range(126,0)))
	
	
	$Path2D/PathFollow2D.progress_ratio = 0.25 #randf_range(0.01,0.5)
	#$Path2D/PathFollow2D/GboxCardImage1.rotation = 0
	#rotate card
	#$Path2D/PathFollow2D/GboxCardImage1.rotate(randf_range(0.1,-0.1))


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
