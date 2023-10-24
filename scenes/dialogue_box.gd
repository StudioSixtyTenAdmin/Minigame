class_name Dialogue
extends PanelContainer

#https://worldeater-dev.itch.io/bittersweet-birthday/devlog/224241/howto-a-simple-dialogue-system-in-godot

@onready var content = get_node("dialogue_text") as RichTextLabel
@onready var timer = get_node("Timer") as Timer
@onready var pause_timer = get_node("PauseTimer") as Timer
@onready var intro_text_complete = true
@onready var _calc = get_node("PauseCalculator") as PauseCalculator
@onready var voice_player = get_node("DialogueVoicePlayer") as AudioStreamPlayer


signal message_completed()

signal choose_price 
signal text_ready
var count = 1
var textLength 
var playing_voice = false
var show_continue = true

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

func _next_text(message):
	_update_message(message)

func _on_text_continue_pressed():
	if count == 1:
		_set_price()
	
	if count == 2:
		get_parent()._dialogue_tree(1)
	
	if count == 3:
		#card Reading Scene
		get_parent()._dialogue_tree(2)
	
	#if count ==4:
	#	get_parent()._dialogue_tree(3)
	
	if count ==4:
		get_parent()._new_client()
		count = 0
	
	
	$text_continue.visible = false
	await text_ready
	count+=1
	
	
func _update_message(message: String):
	
	# Pause detection logic
	content.bbcode_text = _calc.extract_pauses_from_string(message)
	content.visible_characters = 0
	await true_text_length
	
	timer.start()
	
	playing_voice = true
	voice_player.play_play(0)
	
	
func _on_typer_timeout():
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length() - true_text_length:
		content.visible_characters +=1
	else:
		playing_voice = false
		timer.stop()
		emit_signal("message_completed")
		if show_continue == true:
			$text_continue.visible = true
		text_ready.emit()

# Called when the voice player finishes playing the voice clip
func _on_dialogue_voice_player_finished():
	if playing_voice:
		voice_player.play_play(0)

func _on_pause_calculator_pause_requested(duration):
	playing_voice = false
	timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()


func _on_pause_timer_timeout():
	playing_voice = true
	voice_player.play_play(0)
	timer.start()


func _on_pause_calculator_tag_value(x):
	true_text_length = x
	#print ('Output:',true_text_length)

func _on_client_scene_price_set():
	print('price is set')
	_change_show_continue(true)
	$text_continue.visible = true
