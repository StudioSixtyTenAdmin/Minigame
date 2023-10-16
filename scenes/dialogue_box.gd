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
var count = 1
var textLength 

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_message("Florian, a young labourer, [wave]seeks your counsel[/wave], the baker has offered him an apprenticeship, but he has his sights set on another position.")
	textLength = content.text.length()-13



func _on_text_continue_pressed():
	if count == 1:
		_update_message("[wave]Set your price for the reading.[/wave]")
		textLength = content.text.length()-13
		choose_price.emit(intro_text_complete)
	
	if count == 2:
		_update_message("“Sir, the baker has offered to apprentice me, but the blacksmith has no sons and is fond of me. If I were to apprentice for him, I could inherit everything. What do the [wave]cards[/wave] say?”")
		textLength = content.text.length()-13
	
	if count == 3:
		_update_message("[wave]I knew it! Thank you, sir![/wave]")
		textLength = content.text.length()-13
	
	if count == 4:
		_update_message("The Innkeeper seeks your service, his wife has been suffering a dire malaise for a month hence. [wave]What will become of her?[/wave]")
		textLength = content.text.length()
	
	if count == 5:
		_update_message("[wave]Set your price for the reading.[/wave]")
		textLength = content.text.length()-13
		choose_price.emit(intro_text_complete)
	
	if count ==6 
	
	$text_continue.visible = false
	await text_ready
	count+=1
	
	
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

