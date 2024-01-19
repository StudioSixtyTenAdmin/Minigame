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

var true_text_length = 0

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
	#event = true
	#count = 0
	_update_message(message)

func break_into_sentences(paragraph: String) -> Array:
	# Define the delimiter for sentences (assuming sentences end with a period)
	var delimiter = "."

	# Split the paragraph into an array of sentences based on the delimiter
	var sentences = paragraph.split(delimiter)

	# Remove empty strings and trim whitespace from each sentence
	for i in range(sentences.size()):
		sentences[i] = sentences[i].strip_edges()

	return sentences

func _next_text(message):
	print(message)
	for sentance in break_into_sentences(message):
		print(sentance)
		$text_continue_sub.visible = false
		await _update_message(sentance)
		$text_continue_sub.visible = true
		await _on_text_continue_sub_pressed()
		$text_continue_sub.visible = false

func _on_text_continue_main_pressed():
	print('count:',count)
	
	#Event is occuring
	#if count == 0:
	#	get_parent().turn()
	
	if count == 1:
		get_parent().turn()
	
	if count == 2:
		#card Reading Scene
		event = false
		get_parent()._dialogue_tree(2)
	
	#if count ==4:
	#	get_parent()._dialogue_tree(3)
	
	#Reading Ends Here
	if count ==3:
		get_parent().turn()
		print('Setting Count == 1')
		count = 1
	
	$text_continue_main.visible = false
	await text_ready
	
	
	#count+=1
	#print('Adding +1 to count. New count:', count)
	
func _update_message(message: String):
	# Pause detection logic
	content.bbcode_text = _calc.extract_pauses_from_string(message)
	content.visible_characters = 0
	await true_text_length
	
	type_timer.start()
	
	playing_voice = true
	voice_player.play_play(0)
	
	#FIX WHY THE HELL THE TIMER ISN'T WORKING
func _on_type_typer_timeout():
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length() - true_text_length:
		content.visible_characters +=1
	else:
		playing_voice = false
		type_timer.stop()
		emit_signal("message_completed")
		if show_continue == true:
			$text_continue_main.visible = true
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
	#print ('Output:',true_text_length)

func _on_client_scene_price_set():
	print('price is set')
	_change_show_continue(true)
	$text_continue_main.visible = true


func _on_text_continue_sub_pressed():
	pass # Replace with function body.
