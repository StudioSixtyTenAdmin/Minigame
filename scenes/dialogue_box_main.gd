extends Node

@onready var dialogue_manager = $dialogue_window/DialogueManager as DialogueManager






func _on_button_pressed():
	dialogue_manager.show_messages([
		"Anatidaephobia is the fear that, somewhere,{p=0.2} at any given time",
		"[wave amplitude=10]a [rainbow]duck[/rainbow] is watching you...[/wave]",
		"MENACINGLY",
		"But seriously, if a duck was randomly watching me{p=0.2} I would freak out too...",
		"At least it's not a goose,{p=0.2} now THAT's [shake rate=20 level=10]terrifying[/shake]"
	])
