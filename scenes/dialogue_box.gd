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

var true_text_length = 0

#Load Dialogue Text





# Called when the node enters the scene tree for the first time.
#func _ready():
#	_update_message("[wave]Florian[/wave], a [b]young[/b] labourer, [wave]seeks your counsel[/wave],{p=0.5} the baker has offered him an apprenticeship, but he has his sights set on another position.")

func _first_text(message):
	_update_message(message)

func _on_text_continue_pressed():
	if count == 1:
		_update_message("[wave]Set {p=0.1}your [/wave]{p=0.1}[b]price![/b]")
		choose_price.emit(intro_text_complete)
	
	if count == 2:
		_update_message("Sir, the baker has offered to apprentice me, but the blacksmith has no sons and is fond of me.{p=0.5} If I were to apprentice for him, {p=0.1}[wave]I could inherit everything[/wave]. What do the cards say?")
	
	if count == 3:
		_update_message("[wave]I knew[/wave] it!{p=0.1} Thank you, sir!")

	
	if count == 4:
		_update_message("The Innkeeper seeks your service, his wife has been suffering a dire malaise for a month hence. [wave]What will become of her?[/wave]")

	
	if count == 5:
		_update_message("[wave]Set your price for the reading.[/wave]")
		choose_price.emit(intro_text_complete)
	
	
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
