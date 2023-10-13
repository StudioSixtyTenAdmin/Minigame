class_name Dialogue
extends PanelContainer

#https://worldeater-dev.itch.io/bittersweet-birthday/devlog/224241/howto-a-simple-dialogue-system-in-godot

@onready var content = get_node("dialogue_text") as RichTextLabel
@onready var timer = get_node("Timer") as Timer
@onready var intro_text_complete = true
@onready var _calc = get_node("PauseCalculator") as PauseCalculator

signal message_completed()

var linecount = 0
signal choose_price 
signal text_ready

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_message("Florian, a young labourer, [wave]seeks your counsel[/wave], the baker has offered him an apprenticeship, but he has his sights set on another position.")



func _on_text_continue_pressed():
	_update_message("[wave]Set your price for the reading.[/wave]")
	
	$text_continue.visible = false
	await text_ready
	choose_price.emit(intro_text_complete)
	
	
func _update_message(message: String):
	content.bbcode_text = _calc.extract_pauses_from_string(
		message
	)
	
	content.visible_characters = 0
	timer.start()
	
func _on_typer_timeout():
	if content.visible_characters < (content.text.length() - 13):
		content.visible_characters +=1
		$AudioStreamPlayer.playing = true
	else:
		timer.stop()
		$text_continue.visible = true
		text_ready.emit()

