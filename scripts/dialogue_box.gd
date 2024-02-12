class_name Dialogue
extends Control

#https://worldeater-dev.itch.io/bittersweet-birthday/devlog/224241/howto-a-simple-dialogue-system-in-godot

@onready var content = get_node("dialogue_window/dialogue_text") as RichTextLabel
@onready var type_timer = get_node("dialogue_window/TypeTimer") as Timer
@onready var pause_timer = get_node("dialogue_window/PauseTimer") as Timer
@onready var intro_text_complete = true
@onready var _calc = get_node("dialogue_window/PauseCalculator") as PauseCalculator
@onready var voice_player = get_node("dialogue_window/DialogueVoicePlayer") as AudioStreamPlayer


signal message_completed()

signal choose_price 
signal text_ready
var count = 1
var textLength 
var playing_voice = false
var show_continue = true
var event = false
var client_texture = preload('res://assets/ui_art/client-speechbox.png')
var reader_texture = preload('res://assets/ui_art/reader-speechbox-v2.png')

var true_text_length = 0

#Texture Swap
func _texture_swap(client_speaks):
	print('Swapping texture')
	if client_speaks:
		$dialogue_window/Sprite2D.set_texture(client_texture)
	if !client_speaks:
		$dialogue_window/Sprite2D.set_texture(reader_texture)
#Load Dialogue Text

func _change_show_continue(changed_to):
	show_continue = changed_to

func _set_price():
	_update_message("[wave]Set {p=0.1}your [/wave]{p=0.1}[b]price![/b]")
	choose_price.emit(true)
	_change_show_continue(false)
	#await _on_client_scene_price_set()


# Called when the node enters the scene tree for the first time.
#func _ready():
#	_update_message("[wave]Florian[/wave], a [b]young[/b] labourer, [wave]seeks your counsel[/wave],{p=0.5} the baker has offered him an apprenticeship, but he has his sights set on another position.")

func _random_event(message):
	_next_text(message)

func break_into_sentences(paragraph: String) -> Array:
	# Define the delimiters for sentences
	var delimiters = [".", "!", "?", "…"]

	# Initialize an array to hold the sentences
	var sentences = []

	# Initialize an array to hold the delimiters
	var sentence_delimiters = []
	
	# Loop through paragraph to check all instances of any delimeter
	for letter in paragraph:
		for delimiter in delimiters:
			if letter == delimiter:
				sentence_delimiters.push_back(delimiter)

	# Replace all delimiters with a unique delimiter and store the original delimiters
	for delimiter in delimiters:		
		var temp_paragraph = paragraph.replace(delimiter, "<DELIM>")
		if temp_paragraph != paragraph:
			paragraph = temp_paragraph
	print(sentence_delimiters)
	# Split the paragraph into sentences based on the unique delimiter
	var temp_sentences = paragraph.split("<DELIM>")

	# Add the original delimiter back to the end of each sentence
	for i in range(temp_sentences.size() - 1):
		var sentence = temp_sentences[i].strip_edges()
		if sentence != "":
			sentence += sentence_delimiters[i]
			sentences.append(sentence)

	return sentences

func _next_text(message):
	
	var sentance_array = break_into_sentences(message)

	for sentance in sentance_array:
		#one path if this isn't the last sentance in paragraph
		if sentance != sentance_array[sentance_array.size()-1]:
			$text_continue_sub.visible = false
			$text_continue_main.visible = false
			_update_message(sentance)
			await text_ready
			$text_continue_sub.visible = true
			$text_continue_main.visible = false
			await $text_continue_sub.pressed
			$text_continue_sub.visible = false
			$text_continue_main.visible = false
		
		
		#another path if it is the last sentance in paragraph
		if sentance == sentance_array[sentance_array.size()-1]:
			$text_continue_sub.visible = false
			$text_continue_main.visible = false
			_update_message(sentance)
			await text_ready
			$text_continue_sub.visible = false
			$text_continue_main.visible = true
			#await $text_continue_main.pressed
			#$text_continue_sub.visible = false
			#$text_continue_main.visible = false

func _on_text_continue_main_pressed():	
	#Event is occuring
	#if count == 0:/0/
	#	get_parent(0).turn()
	
	if count == 1:
		get_parent().turn()
	
	if count == 2:
		#card Reading Scene
		event = false
		get_parent()._dialogue_tree(2)
	
	
	if count ==3:
		get_parent()._dialogue_tree(3)
	
	#Reading Ends Here
	if count == 4:
		get_parent().turn()
		count = 1
	
	$text_continue_main.visible = false
	await text_ready
	

func _process(_delta):
	$dialogue_window/DialogueVoicePlayer.volume_db = convert_range((get_parent().get_parent().get_parent().volume_value))
	#print($dialogue_window/DialogueVoicePlayer.volume_db)

#update volume correctly
func convert_range(volume):
	return (-40 + (volume / 100.0) * 30)

func convert_type_speed(parent_speed):
	if parent_speed == 1:
		return 0.05
	if parent_speed == 2:
		return 0.04
	if parent_speed == 3:
		return 0.02
	if parent_speed == 4:
		return 0.01
	if parent_speed == 5:
		return 0.005
	if parent_speed == 6:
		return 0.002

func _update_message(message: String):
	# Pause detection logic
	content.bbcode_text = _calc.extract_pauses_from_string(message)
	content.visible_characters = 0
	await true_text_length
	
	type_timer.wait_time = convert_type_speed(get_parent().get_parent().get_parent().typespeed)
	type_timer.start()
	
	playing_voice = true
	voice_player.play_play(0)
	
	#FIX WHY THE HELL THE TIMER ISN'T WORKING

func _on_type_typer_timeout():
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length() - true_text_length:
		
		$text_continue_sub.visible = false
		$text_continue_main.visible = false
		content.visible_characters +=1
	else:
		
		playing_voice = false
		type_timer.stop()
		emit_signal("message_completed")
		#if show_continue == true:
		#$text_continue_main.visible = true
		text_ready.emit()

# Called when the voice player finishes playing the voice clip
func _on_dialogue_voice_player_finished():
	if playing_voice:
		voice_player.play_play(0)

func _on_pause_calculator_pause_requested(duration):
	playing_voice = false
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()


func _on_pause_timer_timeout():
	playing_voice = true
	voice_player.play_play(0)
	type_timer.start()


func _on_pause_calculator_tag_value(x):
	true_text_length = x

#func _on_client_scene_price_set():
#	print('price is set')
#	_change_show_continue(true)
#	$text_continue_main.visible = true


func _on_text_continue_sub_pressed():
	pass # Replace with function body.
